//
//  ViewController.m
//  AppGroupReadOnlyDemo
//
//  Created by Tim Ekl on 2015.02.25.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "ReadOnlySettingViewController.h"

#import <AppGroupFramework/AppGroupFramework.h>

@interface ReadOnlySettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (nonatomic, strong) id userDefaultsChangedObserver;

@end

@implementation ReadOnlySettingViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.userDefaultsChangedObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self updateValueLabel];
    }];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    
    [self updateValueLabel];
}

- (void)updateValueLabel;
{
    self.valueLabel.text = [[NSUserDefaults appGroupUserDefaults] stringForKey:AppGroupSharedUserDefaultsKey];
}

@end
