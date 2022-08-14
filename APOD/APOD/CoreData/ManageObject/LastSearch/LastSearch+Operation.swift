//
//  LastSearch+Operation.swift
//  APOD
//
//  Created by Patel, Mohit on 14/08/22.
//

import Foundation
import CoreData
extension LastSearch {
    /**
     Function to delete last searched object
     - parameter date: date for which object need to delete
     */
    static func deleteLastSearchEntry() {
        let fetchRequest: NSFetchRequest<LastSearch> = LastSearch.fetchRequest()
        do {
            let objects = try AppDelegate.sharedAppDelegate.coreDataStack.managedContext.fetch(fetchRequest)
            for obj in objects {
                AppDelegate.sharedAppDelegate.coreDataStack.managedContext.delete(obj)
            }
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
            print("======Deleted from last search")
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    /**
     Function to save last search object
     - parameter objAPOD: last search obj
     */
    static func saveToLastSearch(objAPOD: APODResponseModel) {
        
        
        let obj = LastSearch(context: AppDelegate.sharedAppDelegate.coreDataStack.managedContext)
        obj.title = objAPOD.title
        obj.hdurl = objAPOD.hdurl
        obj.thumbnail_url = objAPOD.thumbnail_url
        obj.media_type = objAPOD.media_type
        obj.explanation = objAPOD.explanation
        obj.date = objAPOD.date
        obj.url = objAPOD.url
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        print("======Saved to Last Search")
    }

}
