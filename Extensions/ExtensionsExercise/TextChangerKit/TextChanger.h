//
//  TextChanger.h
//  ExtensionDemo
//
//  Created by Tim Ekl on 2015.02.25.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextChanger : NSObject

@property (nonatomic, copy, readonly) NSString *actionTitle;

+ (NSArray *)allChangers;

+ (instancetype)doubler;
+ (instancetype)uppercaser;
+ (instancetype)lowercaser;

- (NSString *)changeText:(NSString *)text;

@end
