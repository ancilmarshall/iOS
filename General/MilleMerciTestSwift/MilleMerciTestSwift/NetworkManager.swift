//
//  BackgroundDownloader.swift
//  MilleMerciTestSwift
//
//  Created by Ancil on 10/3/15.
//  Copyright © 2015 Ancil Marshall. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {

    //properties 
    var downloadCompletionHandler:((data:NSData)->Void)?
    
    func beginBackgroundDownload(url:NSURL, completionHandler:(data:NSData)->Void){
        //cleanUpCache()
        downloadCompletionHandler = completionHandler;
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue())
        let downloadTask = session.downloadTaskWithURL(url)
        downloadTask.resume()
    }
    
    // use a computed property instead of a function to make code cleaner
    var cachedURL: NSURL {
        let url = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory,
            inDomains: .UserDomainMask).first!
        
        let fileURL = url.URLByAppendingPathComponent("downloadedFile")
        return fileURL
    }
    
    func cleanUpCache() {
        do {
            try NSFileManager.defaultManager().removeItemAtURL(cachedURL)
        } catch { print("Something went wrong cleaning up cache")}
    }
}

extension NetworkManager: NSURLSessionDownloadDelegate {
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        if let handler = downloadCompletionHandler,
        let data = NSData(contentsOfURL: location){
            handler(data: data)
        }
        
//        do {
//            try NSFileManager.defaultManager().moveItemAtURL(location, toURL: cachedURL())
//            if let handler = downloadCompletionHandler,
//            let data = NSData(contentsOfURL: cachedURL()){
//                handler(data: data)
//                //cleanUpCache()
//            } else {
//                print("completion handler not yet set")
//            }
//        } catch _ { print("Something Went Wrong") }
    }
}
