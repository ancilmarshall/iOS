//
//  ViewController.m
//  NotificationDemo
//
//  Created by Tim Ekl on 2015.01.12.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "PostingViewController.h"

NSString * const PostingViewControllerNotification = @"PostingViewControllerNotification";
NSString * const PostingViewControllerPostCountKey = @"PostingViewControllerPostCount";

@interface PostingViewController ()

@property (nonatomic, assign) NSUInteger postCount;

@end

@implementation PostingViewController

- (IBAction)postNotification:(id)sender {
    self.postCount ++;
    NSDictionary *userInfo = @{ PostingViewControllerPostCountKey : @(self.postCount) };
    NSNotification *notification = [[NSNotification alloc] initWithName:PostingViewControllerNotification
                                                                 object:self
                                                               userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
