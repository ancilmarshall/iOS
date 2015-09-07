//
//  AppDelegate.m
//  UW_HW6_Ancil
//
//  Created by Ancil on 12/16/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "AppDelegate.h"
#import "CameraViewController.h"
#import "PhotoTableViewController.h"


static const CGFloat kTabBarTileFontSize = 20.0;
static const CGFloat kTabBarTitleVerticalOffset = -10.0;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //setup TabBar properties
    NSDictionary* attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:kTabBarTileFontSize]};
    [[UITabBarItem appearance] setTitleTextAttributes:attributes
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, kTabBarTitleVerticalOffset)];
    
    //setup and add controllers to tabbar controller
    CameraViewController* cameraViewController = [CameraViewController new];
    UINavigationController* cameraNavigationController =
    [[UINavigationController alloc] initWithRootViewController:cameraViewController];
    
    PhotoTableViewController* photoTableViewController = [PhotoTableViewController new];
    UINavigationController* photoNavigationController =
    [[UINavigationController alloc] initWithRootViewController:photoTableViewController];
    
    //these titles are set here so that they are visible when application launches,
    //otherwise, only visible later when their respective tabs are touched
    cameraNavigationController.tabBarItem.title = @"Camera";
    photoNavigationController.tabBarItem.title = @"Photos";
    
    UITabBarController* tabBarController = [UITabBarController new];
    tabBarController.viewControllers = @[cameraNavigationController,photoNavigationController];
    
    //finish up window properties
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
