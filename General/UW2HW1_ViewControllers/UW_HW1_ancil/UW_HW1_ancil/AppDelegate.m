//
//  AppDelegate.m
//  UW_HW1_ancil
//
//  Created by Ancil on 10/2/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "AppDelegate.h"
#import "ColorTabViewController.h"
#import "DataTabViewController.h"
#import "ModelData.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ModelData* data = [[ModelData alloc] init];
    
    ColorTabViewController* colorVC = [[ColorTabViewController alloc] initWithData:data];
    DataTabViewController* dataVC = [[DataTabViewController alloc] initWithData:data];
    UITabBarController* tabBarVC = [[UITabBarController alloc] init];
    [tabBarVC setViewControllers:@[colorVC,dataVC] animated:YES];
    
    self.window.rootViewController = tabBarVC;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
