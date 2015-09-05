//
//  AppDelegate.h
//  CoreDataColors
//
//  Created by Tim Ekl on 2015.01.21.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class ColorManagedObjectContext;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (instancetype)delegate;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) ColorManagedObjectContext *managedObjectContext;

@end

