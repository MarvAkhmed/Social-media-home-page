//
//  Post.swift
//  Patres
//
//  Created by Marwa Awad on 17.03.2025.
//

import UIKit

struct Post {
    let id = UUID()
    let avatarImage: UIImageView
    let username: String
    let postImage: UIImageView
    let caption: String
    let isLiked: Bool?
    
    init(avatarImage: UIImage, username: String, postImage: UIImage, caption: String, isLiked: Bool? = false) {
        self.avatarImage = UIImageView(image: avatarImage)
        self.username = username
        self.postImage = UIImageView(image: postImage)
        self.caption = caption
        self.isLiked = isLiked
    }
}
