//
//  ViewController.m
//  AppGroupDemo
//
//  Created by Tim Ekl on 2015.02.25.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "SettingViewController.h"

#import <AppGroupFramework/AppGroupFramework.h>

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateValueField];
}

- (IBAction)saveValue:(id)sender {
    [[NSUserDefaults appGroupUserDefaults] setObject:[self.valueTextField text]
                                              forKey:AppGroupSharedUserDefaultsKey];
}

- (void)updateValueField;
{
    self.valueTextField.text = [[NSUserDefaults appGroupUserDefaults] stringForKey:AppGroupSharedUserDefaultsKey];
}

@end
