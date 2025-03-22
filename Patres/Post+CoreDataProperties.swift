//
//  Post+CoreDataProperties.swift
//  Patres
//
//  Created by Marwa Awad on 23.03.2025.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var avatarUrl: Data?
    @NSManaged public var caption: String?
    @NSManaged public var id: String?
    @NSManaged public var isLiked: Bool
    @NSManaged public var postImageUrl: Data?
    @NSManaged public var username: String?

}

extension Post : Identifiable {

}
