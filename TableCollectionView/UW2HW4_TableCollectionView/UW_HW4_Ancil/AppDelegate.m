//
//  AppDelegate.m
//  UW_HW4_Ancil
//
//  Created by Ancil on 12/13/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "AppDelegate.h"
#import "BirthdayData.h"
#import "HW4TableViewController.h"
#import "HW4CollectionViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    //setup TabBar properties
    NSDictionary* attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20]};
    [[UITabBarItem appearance] setTitleTextAttributes:attributes
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -10)];

    //setup and add controllers to tabbar controller
    HW4TableViewController* tableVC = [HW4TableViewController new];
    UINavigationController* tableNavC = [[UINavigationController alloc]
                                         initWithRootViewController:tableVC];
    tableNavC.tabBarItem.title = @"List"; // done here to make title visible on app load
    
    HW4CollectionViewController* collectVC = [[HW4CollectionViewController alloc]
        initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    UINavigationController* collectNavC = [[UINavigationController alloc]
                                           initWithRootViewController:collectVC];
    collectNavC.tabBarItem.title = @"Tiles"; // done here to make title visible on app load
    
    UITabBarController* tabBarC = [UITabBarController new];
    tabBarC.viewControllers = @[tableNavC, collectNavC];
    
    //finish up window properties
    self.window.rootViewController = tabBarC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
