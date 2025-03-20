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
    
    
    func reloadTableView(_ tableView: UITableView) {
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
    //MARK: - Networking method (fetching and Parsing the Data from API)
    func fetchPosts() async throws -> [Post]{
        let endpoint = "https://67db5c6b1fd9e43fe47457fa.mockapi.io/getPosts"
        guard let url = URL(string: endpoint) else { throw FetchError.invalidURL}
       
        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([Post].self, from: data)
        } catch {
            throw FetchError.decodingError(error)
        }
        
    }
}
