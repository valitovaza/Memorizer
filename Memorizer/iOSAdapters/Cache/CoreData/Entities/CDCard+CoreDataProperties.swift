//
//  CDCard+CoreDataProperties.swift
//  iOSAdapters
//
//  Created by Azamat Valitov on 21/04/2018.
//
//

import Foundation
import CoreData


extension CDCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCard> {
        return NSFetchRequest<CDCard>(entityName: "CDCard")
    }

    @NSManaged public var id: Int64
    @NSManaged public var frontSide: String?
    @NSManaged public var backSide: String?
    @NSManaged public var pile: CDPile?

}
