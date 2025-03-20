//
//  HomeViewModel.swift
//  Patres
//
//  Created by Marwa Awad on 17.03.2025.
//

import UIKit

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
    
    
    //MARK: - Variables
    private(set) var posts: [Post] = []
    private var isPaginating = false
    var onPostsUpdated: (() -> Void)?
    
    //MARK: - Networking method (fetching and Parsing the Data from API)
    func fetchPosts(pagination: Bool = false) async throws -> [Post] {
        let originalDataEndpoint = "https://67db5c6b1fd9e43fe47457fa.mockapi.io/origialData"
        let paginatedDataEndpoint = "https://67db5c6b1fd9e43fe47457fa.mockapi.io/pagination"
        
        let endpoint = pagination ? paginatedDataEndpoint : originalDataEndpoint
        
        guard let url = URL(string: endpoint) else {  throw FetchError.invalidURL }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([Post].self, from: data)
        } catch let error as DecodingError {
            throw FetchError.decodingError(error)
        } catch {
            throw FetchError.networkError(error)
        }
    }
    
    
}
