//
//  Favorite+Operations.swift
//  APOD
//
//  Created by Patel, Mohit on 14/08/22.
//

import Foundation
import CoreData
/// class that manage all core data oprations
extension Favorite {
    /**
     Function to delete favorite object
     - parameter date: date for which object need to delete
     */
    static func deleteFromFavorite(date: String) {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date)
        do {
            let objects = try AppDelegate.sharedAppDelegate.coreDataStack.managedContext.fetch(fetchRequest)
            for obj in objects {
                AppDelegate.sharedAppDelegate.coreDataStack.managedContext.delete(obj)
            }
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
            print("======Deleted from favorite")
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    /**
     Function to save object as favorite
     - parameter objAPOD: object to be saved as favorite
     */
    static func saveToFavorite(objAPOD: APODResponseModel) {
        
        
        let fav = Favorite(context: AppDelegate.sharedAppDelegate.coreDataStack.managedContext)
        fav.title = objAPOD.title
        fav.hdurl = objAPOD.hdurl
        fav.thumbnail_url = objAPOD.thumbnail_url
        fav.media_type = objAPOD.media_type
        fav.explanation = objAPOD.explanation
        fav.date = objAPOD.date
        fav.url = objAPOD.url
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        print("======Saved to favorite")
    }

    /**
     Function to check if already mark favorite object
     - parameter date: date for which object need to check
     */
    static func isAlreadyMarkedFavorite(date: String) -> Bool {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date)
        do {
            let objects = try AppDelegate.sharedAppDelegate.coreDataStack.managedContext.fetch(fetchRequest)
            if objects.count > 0 {
                return true
            }
            return false
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
            return false
        }
    }
    
    static func fetchFavorites() -> [Favorite] {
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        do {
            let objects = try AppDelegate.sharedAppDelegate.coreDataStack.managedContext.fetch(fetchRequest)
            return objects
            
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
            return []
        }
    }
}
