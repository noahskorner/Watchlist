//
//  ShowEntity+CoreDataProperties.swift
//  Watchlist
//
//  Created by Noah Korner on 4/8/20.
//  Copyright © 2020 asu. All rights reserved.
//
//

import Foundation
import CoreData


extension ShowEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShowEntity> {
        return NSFetchRequest<ShowEntity>(entityName: "ShowEntity")
    }

    @NSManaged public var hasSeen: Bool
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var priorityLevel: Int16
    @NSManaged public var rating: Int16
    @NSManaged public var review: String?
    @NSManaged public var type: Int16
    @NSManaged public var subscriptions: String?

}
