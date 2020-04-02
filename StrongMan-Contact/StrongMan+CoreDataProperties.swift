//
//  StrongMan+CoreDataProperties.swift
//  StrongMan-Contact
//
//  Created by 杨子越 on 2020/4/1.
//  Copyright © 2020 Rabbit. All rights reserved.
//
//

import Foundation
import CoreData


extension StrongMan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StrongMan> {
        return NSFetchRequest<StrongMan>(entityName: "StrongMan")
    }

    @NSManaged public var group: Int16
    @NSManaged public var isStar: Bool
    @NSManaged public var mobile: String?
    @NSManaged public var name: String?
    @NSManaged public var order: Int32
}
