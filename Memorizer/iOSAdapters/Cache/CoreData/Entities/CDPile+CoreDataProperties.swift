//
//  CDPile+CoreDataProperties.swift
//  iOSAdapters
//
//  Created by Azamat Valitov on 21/04/2018.
//
//

import Foundation
import CoreData


extension CDPile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPile> {
        return NSFetchRequest<CDPile>(entityName: "CDPile")
    }

    @NSManaged public var id: Int64
    @NSManaged public var netId: String?
    @NSManaged public var title: String?
    @NSManaged public var createdDate: NSDate?
    @NSManaged public var revisedDate: NSDate?
    @NSManaged public var revisedCount: Int16
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension CDPile {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CDCard)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CDCard)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
