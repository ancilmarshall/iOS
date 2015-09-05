//
//  NSUserDefaults+AppGroupExtensions.m
//  AppGroupDemo
//
//  Created by Tim Ekl on 2015.02.25.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "NSUserDefaults+AppGroupExtensions.h"

NSString * const AppGroupSharedUserDefaultsKey = @"sharedKey";

@implementation NSUserDefaults (AppGroupExtensions)

+ (instancetype)appGroupUserDefaults;
{
    static NSUserDefaults *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithSuiteName:@"group.com.lithium3141.uw.app-group-demo"];
    });
    
    return _instance;
}

@end
