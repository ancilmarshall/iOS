//
//  AppDelegate.h
//  MemeMe
//
//  Created by Ancil on 9/12/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) CameraViewController* cameraViewController;

@end

