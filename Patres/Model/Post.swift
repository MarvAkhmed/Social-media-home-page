//
//  Post.swift
//  Patres
//
//  Created by Marwa Awad on 17.03.2025.
//

import UIKit

struct Post: Decodable {
    let id: String
    let username: String
    let avatarUrl: String
    let postImageUrl: String
    let caption: String
    let isLiked: Bool?
    

}
