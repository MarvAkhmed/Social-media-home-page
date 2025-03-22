//
//  HomeViewModel.swift
//  Patres
//
//  Created by Marwa Awad on 17.03.2025.
//

import UIKit
import CoreData

enum FetchError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
}

class HomeViewModel {
    //MARK: - SingleTone
    static let shared: HomeViewModel = HomeViewModel()
    private init() {}
    
    //MARK: - Variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private(set) var posts: [PostDecoded] = []
    //MARK: - Networking method (fetching and Parsing the Data from API)
    
    /// fetching the posts
    func fetchPosts() async throws -> [PostDecoded] {
        let endpoint = "https://67db5c6b1fd9e43fe47457fa.mockapi.io/origialData"
        guard let url = URL(string: endpoint) else { throw FetchError.invalidURL}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let posts = try decoder.decode([PostDecoded].self, from: data)
            await mapDecodedPostToCoreData(posts: posts)
            return posts
        }catch let error as DecodingError{
            throw FetchError.decodingError(error)
        }catch {
            print("Network error: \(error.localizedDescription)")
            return loadCachedPosts()
        }
    }
    
    /// DTO from DecodedPost to Post
    func mapDecodedPostToCoreData(posts: [PostDecoded]) async {
        for decodedPost in posts {
            
            guard let postId = decodedPost.id,
                !isPostAlreadyExists(id: postId) else {continue}
            
            let post = Post(context: context)
            async let avatarData = downloadImage(from: decodedPost.avatarUrl)
            async let postImageData = downloadImage(from: decodedPost.postImageUrl)
            
            post.id = postId
            post.username = decodedPost.username
            post.caption = decodedPost.caption
            post.isLiked = decodedPost.isLiked
            post.avatarUrl = await avatarData
            post.postImageUrl = await postImageData
        }
        saveToCoreData()
    }
    
    /// make saves on the context
    func saveToCoreData() {
        do {
            try context.save()
        }catch {
            print("Error saving to Core Data: \(error.localizedDescription)")
        }
    }
    
    /// download images from the api(the exact url of the desired image)
    func downloadImage(from urlString: String?) async -> Data? {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            return nil
        }
    }


    //MARK: - Offline mood caching data
    func loadCachedPosts() -> [PostDecoded] {
        let fetchRequests: NSFetchRequest<Post> = Post.fetchRequest()
        do {
            let fetchedPosts = try context.fetch(fetchRequests)
            let decodedPosts  = fetchedPosts.map(mapCoreDataPostToDecodedPost)
            return decodedPosts
        } catch {
            print("Failed to fetch posts: \(error)")
            return []
        }
    }
    /// DTO from Post to DecodedPost
    func mapCoreDataPostToDecodedPost(_ post: Post) -> PostDecoded {
        let avatarFilePath = post.avatarUrl != nil ? saveImageToDocumentsDirectory(imageData: post.avatarUrl!) : nil
        let postImageFilePath = post.postImageUrl != nil ? saveImageToDocumentsDirectory(imageData: post.postImageUrl!) : nil
        let decodedPostDto = PostDecoded(id: post.id,
                                         username: post.username ,
                                         avatarUrl: avatarFilePath,
                                         postImageUrl:  postImageFilePath,
                                         caption: post.caption ?? "no comments!",
                                         isLiked: post.isLiked)
        
        return decodedPostDto
    }
    
    func saveImageToDocumentsDirectory(imageData: Data) -> String? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: fileURL)
            return fileURL.absoluteString
        } catch {
            print("Failed to save image: \(error)")
            return nil
        }
    }
}
//MARK: - needed logic to update the view
extension HomeViewModel {
    func addNewPosts() async throws{
        let newPosts = try await fetchPosts()
        self.posts.append(contentsOf: newPosts)
    }
}
//MARK: - Update the core data(Like button)
extension HomeViewModel {
    
}

//MARK: - General functions to make checks on the core data
extension HomeViewModel {
    /// check if the post already exists
    func isPostAlreadyExists(id: String) -> Bool {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let count = (try? context.count(for: fetchRequest)) ?? 0
        return count > 0
    }
}
