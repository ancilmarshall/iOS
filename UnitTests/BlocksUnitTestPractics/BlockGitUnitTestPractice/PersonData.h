//
//  ViewController.h
//  BlockGitUnitTestPractice
//
//  Created by Ancil on 1/13/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PersonData : NSObject

@property (nonatomic,strong) NSString* firstname;
@property (nonatomic,strong) NSString* lastname;
-(instancetype)initWithFirstName:(NSString*)fname lastName:(NSString*)lname;

@end

