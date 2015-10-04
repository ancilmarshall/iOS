//
//  PhotoViewController.swift
//  MilleMerciTestSwift
//
//  Created by Ancil on 10/3/15.
//  Copyright © 2015 Ancil Marshall. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    var photoData:PhotoData?
    let networkManager = NetworkManager()
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        activity.startAnimating()
        
        if let photoData = photoData {
            navigationItem.title = photoData.title
            networkManager.beginBackgroundDownload(photoData.url) { (imageData) -> Void in
            
                let image = UIImage(data: imageData)!
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.activity.stopAnimating()
                    self.photoImageView.image = image;
                }
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        dispatch_async(dispatch_get_main_queue()) {
            self.activity.stopAnimating()
            self.photoImageView.image = nil;
        }
    }


}
