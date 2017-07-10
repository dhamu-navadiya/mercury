//
//  Category+CoreDataProperties.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 5/4/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var cat_name: String?
    @NSManaged public var users: NSSet?

}

// MARK: Generated accessors for users
extension Category {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: Users)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: Users)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}
