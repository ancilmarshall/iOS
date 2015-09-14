//
//  AppDelegate.h
//  MilleMercisTest
//
//  Created by Ancil on 9/9/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)delegate;
- (void)viewController:(PhotoViewController*)viewController  beginBackgroundDownloadForURL:(NSURL*)url;
@end

