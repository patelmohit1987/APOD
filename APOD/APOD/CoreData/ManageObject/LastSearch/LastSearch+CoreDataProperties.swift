//
//  LastSearch+CoreDataProperties.swift
//  APOD
//
//  Created by Patel, Mohit on 14/08/22.
//
//

import Foundation
import CoreData


extension LastSearch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastSearch> {
        return NSFetchRequest<LastSearch>(entityName: "LastSearch")
    }

    @NSManaged public var date: String?
    @NSManaged public var explanation: String?
    @NSManaged public var hdurl: String?
    @NSManaged public var media_type: String?
    @NSManaged public var thumbnail_url: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?

}

extension LastSearch : Identifiable {

}
