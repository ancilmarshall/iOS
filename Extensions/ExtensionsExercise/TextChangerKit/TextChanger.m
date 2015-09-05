//
//  TextChanger.m
//  ExtensionDemo
//
//  Created by Tim Ekl on 2015.02.25.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "TextChanger.h"

@interface TextDoubler : TextChanger
@end

@implementation TextDoubler

- (NSString *)actionTitle;
{
    return @"Double";
}

- (NSString *)changeText:(NSString *)text;
{
    return [NSString stringWithFormat:@"%@%@", text, text];
}

@end

@interface TextUppercaser : TextChanger
@end

@implementation TextUppercaser

- (NSString *)actionTitle;
{
    return @"Uppercase";
}

- (NSString *)changeText:(NSString *)text;
{
    return [text uppercaseString];
}

@end

@interface TextLowercaser : TextChanger
@end

@implementation TextLowercaser

- (NSString *)actionTitle;
{
    return @"Lowercase";
}

- (NSString *)changeText:(NSString *)text;
{
    return [text lowercaseString];
}

@end

@implementation TextChanger

+ (NSArray *)allChangers;
{
    return @[ [self doubler], [self uppercaser], [self lowercaser] ];
}

+ (instancetype)doubler;
{
    return [self changerOfClass:[TextDoubler class]];
}

+ (instancetype)uppercaser;
{
    return [self changerOfClass:[TextUppercaser class]];
}

+ (instancetype)lowercaser;
{
    return [self changerOfClass:[TextLowercaser class]];
}

- (NSString *)changeText:(NSString *)text;
{
    // No explicit behavior specified
    return text;
}

#pragma mark - Private

+ (instancetype)changerOfClass:(Class)cls;
{
    NSParameterAssert([cls isSubclassOfClass:self]);
    return [[cls alloc] init];
}

@end
