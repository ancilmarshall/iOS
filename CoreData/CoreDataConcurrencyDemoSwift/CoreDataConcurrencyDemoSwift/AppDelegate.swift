//
//  AppDelegate.swift
//  CoreDataConcurrencyDemoSwift
//
//  Created by Ancil on 10/4/15.
//  Copyright © 2015 Ancil Marshall. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootManagedObjectContext: NSManagedObjectContext?
    
    class func delegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        guard let momURL =
            NSBundle.mainBundle().URLForResource("Model", withExtension: "momd") else
        {
            print("Unable to find Core Data Model URL")
            return false
        }
        
        guard let mom = NSManagedObjectModel(contentsOfURL: momURL) else {
            print("Unable to create a MOM")
            return false
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        do {
            try psc.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
        } catch _ {
            print("Error adding persistent store to PSC")
        }
        
        rootManagedObjectContext =
            NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        rootManagedObjectContext?.persistentStoreCoordinator = psc
        
        
        return true
    }



}

