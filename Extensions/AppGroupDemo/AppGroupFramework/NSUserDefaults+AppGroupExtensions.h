//
//  NSUserDefaults+AppGroupExtensions.h
//  AppGroupDemo
//
//  Created by Tim Ekl on 2015.02.25.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const AppGroupSharedUserDefaultsKey;

@interface NSUserDefaults (AppGroupExtensions)

/// Works like +standardUserDefaults, but places its key/value pairs into the shared container for this Xcode project.
+ (instancetype)appGroupUserDefaults;

@end
