//
//  AppDelegate.m
//  NotificationDemo
//
//  Created by Tim Ekl on 2015.01.12.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "AppDelegate.h"
#import "PostingViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) id viewControllerPostingObserver;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.viewControllerPostingObserver = [[NSNotificationCenter defaultCenter]
                                          addObserverForName:PostingViewControllerNotification
                                          object:nil
                                          queue:[NSOperationQueue mainQueue]
                                          usingBlock:^(NSNotification *note) {
                                              NSNumber *postNumber = note.userInfo[PostingViewControllerPostCountKey];
                                              NSLog(@"VC %@ posted a notification", note.object);
                                              NSLog(@"this is notification number %@", postNumber);
                                          }];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] removeObserver:self.viewControllerPostingObserver];
}

@end
