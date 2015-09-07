//
//  AppDelegate.m
//  UW_HW3_Ancil
//
//  Created by Ancil on 11/28/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

extern NSString* const kUserDefaultBackgroundColor;
extern NSString* const kUserDefaultCorderRadius;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc]
                    initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [ViewController new];
    [self.window makeKeyAndVisible];
    
    //setup user defaults and register with notification center to synchronize
    [[NSUserDefaults standardUserDefaults]
        registerDefaults:@{kUserDefaultBackgroundColor:@"red",
                           kUserDefaultCorderRadius:@(0.5)}];
    
    [[NSNotificationCenter defaultCenter]
             addObserverForName:NSUserDefaultsDidChangeNotification
             object:[NSUserDefaults standardUserDefaults]
             queue:[NSOperationQueue mainQueue]
             usingBlock:^(NSNotification *note)
                {
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
     ];

    return YES;
}

@end
