//
//  HomeViewModel.swift
//  Patres
//
//  Created by Marwa Awad on 17.03.2025.
//

import UIKit

class HomeViewModel {
    
    //MARK: - SingleTone
    static var shared: HomeViewModel {
        return instance
    }
    private static var instance: HomeViewModel = {
        let homeViewModel = HomeViewModel()
        return homeViewModel
    }()
    
    private init() {}
    
    //MARK: - Variabels
    let post = Post(avatarImage: (UIImage(named: "image") ?? UIImage(systemName: "person"))!, username: "username", postImage: UIImage(named: "image")! , caption: "caption")
}
