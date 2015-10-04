//
//  PhotoListViewController.swift
//  MilleMerciTestSwift
//
//  Created by Ancil on 10/3/15.
//  Copyright © 2015 Ancil Marshall. All rights reserved.
//

import UIKit

class PhotoListViewController: UITableViewController {

    var photoManager = PhotoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Photos"
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoManager.photos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        let photoData = photoManager.photos[indexPath.row]
        cell.textLabel?.text = photoData.title
        return cell
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let vc = segue.destinationViewController as? PhotoViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.photoData = photoManager.photos[indexPath.row]
            }
        }
    }
}
