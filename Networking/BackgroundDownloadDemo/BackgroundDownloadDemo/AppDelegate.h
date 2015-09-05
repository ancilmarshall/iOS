//
//  AppDelegate.h
//  BackgroundDownloadDemo
//
//  Created by Tim Ekl on 2015.02.09.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)delegate;
- (void)beginBackgroundDownload;

@end

