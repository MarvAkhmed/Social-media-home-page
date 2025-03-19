//
//  HomeViewModel.swift
//  Patres
//
//  Created by Marwa Awad on 17.03.2025.
//

import UIKit

class HomeViewModel {
    
    //MARK: - SingleTone
    static let shared: HomeViewModel = HomeViewModel()
    private init() {}
    
    //MARK: - Variabels
    let post = Post(avatarImage: (UIImage(named: "image") ?? UIImage(systemName: "person"))!, username: "username", postImage: UIImage(named: "image")! , caption: "caption")
}
