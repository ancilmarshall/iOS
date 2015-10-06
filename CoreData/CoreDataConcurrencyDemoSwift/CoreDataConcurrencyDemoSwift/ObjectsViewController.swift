//
//  ObjectsViewController.swift
//  CoreDataConcurrencyDemoSwift
//
//  Created by Ancil on 10/4/15.
//  Copyright © 2015 Ancil Marshall. All rights reserved.
//

import UIKit
import CoreData

class ObjectsViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    
    var parentContext:NSManagedObjectContext?
    var childContext:NSManagedObjectContext?
    var childContextNotificationToken:AnyObject?
    var parentContextNotificationToken:AnyObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        parentContext = AppDelegate.delegate().rootManagedObjectContext
        updateCountLabel()
        
        parentContextNotificationToken =  NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification, object: parentContext, queue: NSOperationQueue.mainQueue(), usingBlock: { (note:NSNotification) -> Void in
            self.updateCountLabel()
        })
        
    }
    
    
    func updateCountLabel(){
        let request = NSFetchRequest(entityName: "StringEntity")
        var stringEntities:[AnyObject]?
        do {
            try stringEntities = parentContext?.executeFetchRequest(request)
        } catch {
            print("Error fetching from parent context")
        }
        countLabel.text = "\(stringEntities!.count) Objects"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showEditor" {
            
            let childContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            guard (parentContext != nil) else {
                print("Parent Context not yet set")
                return
            }
            childContext.parentContext = parentContext
            
            
            childContextNotificationToken =  NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification, object: childContext, queue: NSOperationQueue.mainQueue(), usingBlock: { (note:NSNotification) -> Void in
                self.parentContext?.mergeChangesFromContextDidSaveNotification(note)
                do {
                    try self.parentContext?.save()
                } catch _ {
                    print("Problems saving parent context")
                }
            })
            
            
            let vc = (segue.destinationViewController as! UINavigationController).topViewController as! EditorViewController
            vc.context = childContext
            vc.delegate = self
            
        }
        
    }
}

extension ObjectsViewController: EditorViewControllerDelegate {

    func cancelEditor(){
        
        //childContextNotificationToken = nil
    }
    
    func saveEditor(){
        
        do {
            try childContext?.save()
        } catch _ {
            print("Problems saving child context")
        }
        
        cancelEditor()
    }
    

}
