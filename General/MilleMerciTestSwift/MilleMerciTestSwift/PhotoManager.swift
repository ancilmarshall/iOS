//
//  PhotoManager.swift
//  MilleMerciTestSwift
//
//  Created by Ancil on 10/3/15.
//  Copyright © 2015 Ancil Marshall. All rights reserved.
//

import UIKit

class PhotoManager: NSObject {

    var photos = Array<PhotoData>()
    
    override init(){
        
        super.init()

        guard let url = NSBundle.mainBundle().pathForResource("photos", ofType: "plist") else {
            print("photo plist not found")
            return
        }
        
        guard let dict = NSDictionary(contentsOfFile: url) else {
            print("unable to read photo plist url")
            return
        }
        
        dict.enumerateKeysAndObjectsUsingBlock { (key, value, stop) -> Void in

            guard let data = value as? Dictionary<String,String> else {
                print("Expected a Dictionary<String,String> in photo plist item")
                return
            }
            
            if let title = data["title"], let urlString = data["url"] {
                if let url = NSURL(string: urlString) {
                    self.photos.append(PhotoData(title:title,url:url))
                }
            }
        }

    }
}
