//
//  UWCollectionViewController.swift
//  UWCollectionViewDemoSwift
//
//  Created by Ancil on 10/4/15.
//  Copyright © 2015 Ancil Marshall. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

extension UIColor {
    
    class func randomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}

class UWCollectionViewController: UICollectionViewController {

    var colors = [UIColor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView!.backgroundColor = UIColor.whiteColor()
    }


    @IBAction func addColor(sender: UIBarButtonItem) {
        colors.append(UIColor.randomColor())
        let indexPath = NSIndexPath(forRow: colors.count-1, inSection: 0)
        self.collectionView!.insertItemsAtIndexPaths([indexPath])
    }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        let color = colors[indexPath.item]
        cell.backgroundColor = color
        return cell
    }
    
}

extension UWCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let edge:CGFloat = collectionView.frame.size.width / 4.0
        return CGSizeMake(edge, edge)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
}
