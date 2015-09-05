//
//  Color+Extensions.m
//  CoreDataColors
//
//  Created by Tim Ekl on 2015.01.21.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "Color+Extensions.h"

@implementation Color (Extensions)

- (UIColor *)UIColor;
{
    return [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:self.alpha];
}

- (void)setUIColor:(UIColor *)color;
{
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    self.red = red;
    self.green = green;
    self.blue = blue;
    self.alpha = alpha;
}

@end
