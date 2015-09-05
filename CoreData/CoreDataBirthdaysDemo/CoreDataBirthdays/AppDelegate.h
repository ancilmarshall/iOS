//
//  AppDelegate.h
//  CoreDataBirthdays
//
//  Created by Tim Ekl on 2015.01.28.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (instancetype)delegate;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong, readonly) NSManagedObjectContext *rootManagedObjectContext;

@end

