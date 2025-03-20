//
//  Post.swift
//  Patres
//
//  Created by Marwa Awad on 17.03.2025.
//

import UIKit

struct PostL: Decodable {
    let id: String
    let username: String
    var avatarUrl: String?
    let postImageUrl: String
    let caption: String
    let isLiked: Bool?

}
