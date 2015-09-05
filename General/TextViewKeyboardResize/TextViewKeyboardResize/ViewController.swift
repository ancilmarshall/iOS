//
//  ViewController.swift
//  TextViewKeyboardResize
//
//  Created by Ancil on 8/4/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    @IBOutlet weak var inputTextView: ResizableTextView!
    @IBOutlet weak var bottomView: ResizableView!
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var pushButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resizableHeightConstraint: NSLayoutConstraint!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //customize the image view
        customImageView.image = UIImage(named: "placeholderImage44.jpg")
        customImageView.clipsToBounds = true
        customImageView.layer.cornerRadius = CGRectGetHeight(customImageView.frame)/2.0
        
        inputTextView.layer.cornerRadius = 10.0
        inputTextView.clipsToBounds = true
        
        //customize the push button
        pushButton.layer.cornerRadius = 10.0
        pushButton.clipsToBounds = true
        
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: tableData.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //setup keyboard notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillAppear:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillDisappear:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //must remove self from notification center when view disappears
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //MARK:- Keyboard Notifications
    func keyboardWillAppear(notification: NSNotification){
        if let userInfo = notification.userInfo as? Dictionary<String,AnyObject>  {
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
            let keyboardheight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height
            
            if let height = keyboardheight {
                if let duration = animationDuration {
                    UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                        
                        //get the screen size
                        let screenHeight = UIScreen.mainScreen().bounds.size.height
                        self.view.frame.size.height = screenHeight - height
                        self.view.setNeedsLayout()
                        self.view.layoutIfNeeded()
                        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.tableData.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
                        }, completion: nil)
                }
            }
        }
    }
    
    func keyboardWillDisappear(notification: NSNotification){
        if let userInfo = notification.userInfo as? Dictionary<String,AnyObject>  {
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
            let keyboardheight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height
            
            if let height = keyboardheight {
                //get the screen size
                let screenHeight = UIScreen.mainScreen().bounds.size.height
                self.view.frame.size.height = screenHeight
                self.view.setNeedsLayout()
                
                if let duration = animationDuration {
                    UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                            self.view.layoutIfNeeded()
                        }, completion: nil)
                }
            }
        }        
    }

    
    //MARK:- Tap Gesture
    @IBAction func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            inputTextView.resignFirstResponder()
        }
    }
    
    //MARK:- TableView Data Source
    var tableData = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
    
        var row = indexPath.row
        var num = tableData[row]
        cell.textLabel?.text = "\(num)"
    return cell
    }
    
    //MARK:- Text View Delegate
    func textViewDidChange(textView: UITextView) {
        //println("changed")
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: tableData.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)

    }
    

    
    //MARK:- Target/Action
    @IBAction func addLongText(sender: UIButton) {
        
        var longText = "John Forbes Nash Jr. (June 13, 1928 – May 23, 2015) was " +
                       "an American mathematician with fundamental contributions " +
                       "in game theory, differential geometry, and partial differential " +
                       "equations. Nash's work has provided insight into the factors " +
                       "that govern chance and decision making inside complex systems in " +
                       "daily life"
        
        inputTextView?.text = longText
        //force the runtime to immediately update the constraints and animate the layout changes
        //NOTE: adapted from Nikita2k/resizableTextView on GitHub
        
        inputTextView.setNeedsUpdateConstraints()
        inputTextView.updateConstraintsIfNeeded()

        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
            { () -> Void in
                self.view.layoutIfNeeded()
            },
            completion: nil)
    }
    
    @IBAction func push(sender: UIButton) {
        //println("Pushed")
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 19, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    
}

