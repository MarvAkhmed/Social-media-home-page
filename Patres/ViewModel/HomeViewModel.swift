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
    case noData
}

class HomeViewModel {
    //MARK: - SingleTone
    static let shared: HomeViewModel = HomeViewModel()
    private init() {}
    
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //MARK: - Networking method (fetching and Parsing the Data from API)
    func fetchPosts(pagination: Bool = false) async throws -> [PostDecoded] {
        let originalDataEndpoint = "https://67db5c6b1fd9e43fe47457fa.mockapi.io/origialData"
        let paginatedDataEndpoint = "https://67db5c6b1fd9e43fe47457fa.mockapi.io/pagination"
        
        let endpoint = pagination ? paginatedDataEndpoint : originalDataEndpoint
        
        guard let url = URL(string: endpoint) else {  throw FetchError.invalidURL }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([PostDecoded].self, from: data)
        } catch let error as DecodingError {
            throw FetchError.decodingError(error)
        } catch {
            throw FetchError.networkError(error)
        }
    }
    
    //MARK: - DTO from DecodedPost to Post
    
    /// check if the post already exists
    func isPostAlreadyExists(id: String) -> Bool {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let count = (try? context.count(for: fetchRequest)) ?? 0
        return count > 0
    }
    
    ///convert the api model(PostDecoded) into the coredata model(Post)
    func mapDecodedPostToCoreData(posts: [PostDecoded]) {
        for decodedPost in posts {
            if !isPostAlreadyExists(id: decodedPost.id!) {
                let post = Post(context: context)
                post.id = decodedPost.id
                post.username = decodedPost.username
                post.avatarUrl = decodedPost.avatarUrl
                post.postImageUrl = decodedPost.postImageUrl
                post.caption = decodedPost.caption
                post.isLiked = decodedPost.isLiked
            }
        }
        do {
            try context.save()
            print("successfully saved")
        }catch {
            print("Failed to save posts: \(error.localizedDescription)")
        }
    }
    
    ///convert the model(Post) a into the coredatapi model(PostDecoded)
    func mapCoreDataPostToDecodedPost() -> [PostDecoded] {
        let fetchRequests: NSFetchRequest<Post> = Post.fetchRequest()
        do {
            let fetchedPosts = try context.fetch(fetchRequests)
            
            let decodedPosts = fetchedPosts.map { post in
                return PostDecoded(id: post.id ?? "",
                                   username: post.username ?? "",
                                   avatarUrl: post.avatarUrl ?? "",
                                   postImageUrl: post.postImageUrl ?? "",
                                   caption: post.caption ?? "",
                                   isLiked: post.isLiked
                )
            }
            return decodedPosts
        } catch {
            print("Failed to fetch posts: \(error)")
            return []
        }
    }
}
