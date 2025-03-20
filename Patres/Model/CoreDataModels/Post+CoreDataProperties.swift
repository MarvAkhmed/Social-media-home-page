//
//  Post+CoreDataProperties.swift
//  Patres
//
//  Created by Marwa Awad on 20.03.2025.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var avaratUrl: String?
    @NSManaged public var caption: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isLiked: Bool
    @NSManaged public var postImageUrl: String?
    @NSManaged public var username: String?

}

extension Post : Identifiable {

}
