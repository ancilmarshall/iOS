//
//  MovableView.h
//  UW_HW3_Ancil
//
//  Created by Ancil on 11/28/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;

@interface MovableView : UIView

+(void)addToViewController:(ViewController*)parentViewController
                  atCenter:(CGPoint)center;
+(NSArray*)movableViewColors;

@end

