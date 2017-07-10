//
//  Users+CoreDataProperties.swift
//  Mercury App IOS
//
//  Created by manish tiwari on 5/4/17.
//  Copyright © 2017 Vizista Technologies. All rights reserved.
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var email: String?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var country: String?
    @NSManaged public var zipcode: Int16
    @NSManaged public var category: Category?

}
