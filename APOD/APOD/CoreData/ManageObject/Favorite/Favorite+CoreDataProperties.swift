//
//  Favorite+CoreDataProperties.swift
//  APOD
//
//  Created by Patel, Mohit on 14/08/22.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var date: String?
    @NSManaged public var explanation: String?
    @NSManaged public var media_type: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var hdurl: String?
    @NSManaged public var thumbnail_url: String?

}

extension Favorite : Identifiable {

}
