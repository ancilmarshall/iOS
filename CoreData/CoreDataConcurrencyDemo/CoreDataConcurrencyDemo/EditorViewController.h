//
//  EditorViewController.h
//  CoreDataConcurrencyDemo
//
//  Created by Tim Ekl on 2015.01.18.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditorViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *context;

@end
