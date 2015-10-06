//
//  EditorViewController.swift
//  CoreDataConcurrencyDemoSwift
//
//  Created by Ancil on 10/4/15.
//  Copyright © 2015 Ancil Marshall. All rights reserved.
//

import UIKit
import CoreData

class EditorViewController: UIViewController, UITextFieldDelegate {

    var object:NSManagedObject?
    var delegate:EditorViewControllerDelegate?
    @IBOutlet weak var inputText:UITextField!
    
    var context:NSManagedObjectContext? {
        didSet {
            object = NSEntityDescription.insertNewObjectForEntityForName("StringEntity", inManagedObjectContext: context!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
            return true
    }
    
    
    @IBAction func save(){
        if let delegate = delegate {
            object?.setValue(inputText.text, forKey: "string")
            delegate.saveEditor()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func cancel(){
        if let delegate = delegate {
            delegate.cancelEditor()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

}


protocol EditorViewControllerDelegate {
    
    func saveEditor()
    func cancelEditor()
}