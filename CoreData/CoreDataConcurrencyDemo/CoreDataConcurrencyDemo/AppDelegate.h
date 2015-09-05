//
//  AppDelegate.h
//  CoreDataConcurrencyDemo
//
//  Created by Tim Ekl on 2015.01.18.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

//expose delegate
+ (instancetype)delegate;

@property (strong, nonatomic) UIWindow *window;

//expose rootManagedObjectContext
@property (nonatomic, strong, readonly) NSManagedObjectContext *rootManagedObjectContext;

@end

