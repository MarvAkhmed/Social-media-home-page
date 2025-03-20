//
//  Post+CoreDataProperties.swift
//  Patres
//
//  Created by Marwa Awad on 21.03.2025.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var id: String?
    @NSManaged public var username: String?
    @NSManaged public var avatarUrl: String?
    @NSManaged public var postImageUrl: String?
    @NSManaged public var caption: String?
    @NSManaged public var isLiked: Bool

}

extension Post : Identifiable {

}
