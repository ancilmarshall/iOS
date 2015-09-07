//
//  MovableView.m
//  A view that can be moved using a pan gesture.
//  Is initialized with a given center position and parent view controller
//  Note: Could have used a datasource protocol to get the keep out zones
//        and add logic to better buffer the zones, and better rotation support
//
//  UW_HW3_Ancil
//
//  Created by Ancil on 11/28/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "MovableView.h"
#import "ViewController.h"

static const CGFloat kSide = 50.0f;
static const CGFloat kCornerRadiusRatio = 0.3333f;
NSString* const kUserDefaultBackgroundColor = @"backgroundColor";
NSString* const kUserDefaultCorderRadius = @"cornerRadius";

@interface MovableView()

@property (nonatomic,strong) ViewController* parentViewController;
@property (nonatomic,strong) NSLayoutConstraint* verticalConstraint;
@property (nonatomic,strong) NSLayoutConstraint* horizontalConstraint;
@property (nonatomic,strong) UIPanGestureRecognizer* panGesture;
@property (nonatomic,strong) UIColor* userDefaultsBackGroundColor;
@property (nonatomic,assign) CGFloat userDefaultsCornerRadius;

@end

@implementation MovableView

#pragma mark - Initialization

+(void)addToViewController:(ViewController*)parentViewController
                  atCenter:(CGPoint)center;
{
    
    MovableView* view = [MovableView new];
    view.parentViewController = parentViewController;
    [parentViewController.view addSubview:view];
    view.backgroundColor = view.userDefaultsBackGroundColor;
    
    // Contraint view in the parent view controller's view
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.verticalConstraint =
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:parentViewController.topLayoutGuide
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:center.y];
    
    view.horizontalConstraint =
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:parentViewController.view
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:center.x];
    
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:0.0
                                  constant:kSide].active = YES;
    
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:0.0
                                  constant:kSide].active = YES;
    
    [NSLayoutConstraint activateConstraints:@[view.verticalConstraint,
                                              view.horizontalConstraint]];
    
    [parentViewController.view layoutIfNeeded];
    
    // Setup Pan Gesture Recognizer
    view.panGesture = [[UIPanGestureRecognizer alloc]
                       initWithTarget:view
                       action:@selector(pan:)];
    [view addGestureRecognizer:view.panGesture];

    [view changeCornerRadius];
    
    // Register view for NSUserDefaultsDidChangeNotification
    [[NSNotificationCenter defaultCenter]
        addObserver:view
        selector:@selector(userDefaultsDidChange)
        name:NSUserDefaultsDidChangeNotification
        object:[NSUserDefaults standardUserDefaults]];
    
}

#pragma mark - Pan Gesture
-(void)pan:(UIPanGestureRecognizer*)panGesture;
{
    CGPoint location = [panGesture locationInView:self.parentViewController.view];
    
    if ( CGRectContainsPoint([self.parentViewController keepOutZones], location))
    {
        return;
    }
    if ( panGesture.state == UIGestureRecognizerStateChanged )
    {
        CGPoint translation = [panGesture translationInView:self];
        self.horizontalConstraint.constant += translation.x;
        self.verticalConstraint.constant += translation.y;
        [panGesture setTranslation:CGPointZero inView:self];
    }
}

#pragma mark - User Preferences change methods
/*
 *  Use this dictionary to have one location of the available colors. The
 *  keys can be used as available string array of colors, while the dictionary
 *  is used to lookup UIColors based on key string
 */
+(NSDictionary*)backgroundColorsDictionary;
{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    dict[@"red"] = [UIColor redColor];
    dict[@"green"] = [UIColor greenColor];
    dict[@"blue"] = [UIColor blueColor];
    return dict;
}

/*
 *  Return the available background colors for the MovableView class
 */
+(NSArray*)movableViewColors;
{
    return [[MovableView backgroundColorsDictionary] allKeys];
}

/*
 *  This selector is called by the NSNotificationCenter when the NSUserDefaults
 *  have been changed, and updates both the background color and corner radius
 */
-(void)userDefaultsDidChange;
{
    [self setBackgroundColor:self.userDefaultsBackGroundColor];
    [self changeCornerRadius];
}

-(void)changeCornerRadius
{
    CGFloat radius = self.userDefaultsCornerRadius*kSide*kCornerRadiusRatio;
    [self.layer setCornerRadius:radius];
}

#pragma mark - Getters for userDefaultBackGroundColor with NSUserDefaults

//NOTE: Need to synthesize here since the getter and setter are implemented
//@synthesize userDefaultsBackGroundColor;

-(UIColor*)userDefaultsBackGroundColor;
{
    NSString* colorKey = [[NSUserDefaults standardUserDefaults]
                        stringForKey:kUserDefaultBackgroundColor];
    
    return [MovableView backgroundColorsDictionary][colorKey];
}

-(CGFloat)userDefaultsCornerRadius;
{
    NSNumber* radiusAsNumber = [[NSUserDefaults standardUserDefaults]
                                objectForKey:kUserDefaultCorderRadius];
    
    return [radiusAsNumber floatValue];

}
//-(void)setUserDefaultBackGroundColor:(NSString*)color;
//{
//    [[NSUserDefaults
//      standardUserDefaults] setObject:color
//                               forKey:kUserDefaultBackgroundColor];
//}

@end
