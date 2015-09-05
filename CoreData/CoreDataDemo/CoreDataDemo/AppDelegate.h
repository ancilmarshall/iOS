//
//  AppDelegate.h
//  CoreDataDemo
//
//  Created by Tim Ekl on 2015.01.13.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (instancetype)sharedDelegate;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@end

