//
//  AppDelegate.swift
//  APOD
//
//  Created by Patel, Mohit on 10/08/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    lazy var coreDataStack: CoreDataStack = .init(modelName: "APOD")
    
    static let sharedAppDelegate: AppDelegate = {
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
                fatalError("Unexpected app delegate type \(String(describing: UIApplication.shared.delegate))")
            }
            return delegate
        }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }

    
    
}

