//
//  AppDelegate.m
//  MemeMe
//
//  Created by Ancil on 9/12/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "AppDelegate.h"
#import "PhotoTableViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //setup and add controllers to tabbar controller
    self.cameraViewController = [CameraViewController new];
    UINavigationController* cameraNavigationController =
    [[UINavigationController alloc] initWithRootViewController:self.cameraViewController];
    
    //finish up window properties
    self.window.rootViewController = cameraNavigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
