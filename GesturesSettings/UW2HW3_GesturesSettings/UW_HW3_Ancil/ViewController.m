//
//  ViewController.m
//  UW_HW3_Ancil
//
//  Created by Ancil on 11/28/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "MovableView.h"
#import "ViewController.h"

extern NSString* const kUserDefaultBackgroundColor;
extern NSString* const kUserDefaultCorderRadius;

@interface ViewController ()
@property (nonatomic,strong) UITapGestureRecognizer* tapGesture;
@property (nonatomic,strong) UISegmentedControl* backgroundColorControl;
@property (nonatomic,strong) UISlider* cornerRadiusControl;
@end

@implementation ViewController

#pragma mark - Initialization and Gui Updates
/*
 * Loads the view
 */
-(void)loadView;
{
    UIView* mainView = [[UIView alloc] initWithFrame:
                            [[UIScreen mainScreen] bounds]];
    mainView.backgroundColor = [UIColor whiteColor];
    self.view = mainView;

    
}

/*
 * Setup up the view (one-time initialization)
 */
- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    //add tap Gesture recognizer
    self.tapGesture = [[UITapGestureRecognizer alloc]
                        initWithTarget:self
                                action:@selector(tapped:)];
    [self.view addGestureRecognizer:self.tapGesture];
    
    //add segment control of background colors
    self.backgroundColorControl = [[UISegmentedControl alloc] init];
    self.backgroundColorControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.backgroundColorControl];
    
    [NSLayoutConstraint constraintWithItem:self.backgroundColorControl
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.topLayoutGuide
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.backgroundColorControl
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0].active = YES;
    
    [self.backgroundColorControl addTarget:self
                                    action:@selector(chooseBackgroundColor:)
                          forControlEvents:UIControlEventValueChanged];
    
    [self.backgroundColorControl removeAllSegments];
    NSArray* colors = [MovableView movableViewColors];
    for (int i=0; i<[colors count]; i++)
    {
        [self.backgroundColorControl insertSegmentWithTitle:colors[i]
                                              atIndex:i
                                             animated:NO];
    }
    
    [self updateBackgroundControlGui];
    
    //Setup slider controller for the corner radius control
    self.cornerRadiusControl = [UISlider new];
    self.cornerRadiusControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.cornerRadiusControl.minimumValue = 0.0f;
    self.cornerRadiusControl.maximumValue = 1.0f;
    self.cornerRadiusControl.userInteractionEnabled = YES;

    [self.view addSubview:self.cornerRadiusControl];
    
    [NSLayoutConstraint constraintWithItem:self.cornerRadiusControl
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.cornerRadiusControl
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.backgroundColorControl
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0f
                                  constant:10.0f].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.cornerRadiusControl
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:0.0f
                                  constant:100.0f].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.cornerRadiusControl
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:0.0f
                                  constant:40.0f].active = YES;
    
    
    [self.cornerRadiusControl addTarget:self
                                 action:@selector(chooseCornerRadius:)
                       forControlEvents:UIControlEventValueChanged];
     
    [self updateCornerRadiusControlGui];
    
    //Register this view controller with notification center to take action
    //when user defaults changed throughout system.
    [[NSNotificationCenter defaultCenter]
                           addObserver:self
                              selector:@selector(updateGui)
                                  name:NSUserDefaultsDidChangeNotification
                                object:[NSUserDefaults standardUserDefaults]];
    
    [self.view setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
}

/*
 * Called when NSUserDefaults has been changed. Updates all Gui elements
 */
-(void) updateGui
{
    [self updateBackgroundControlGui];
    [self updateCornerRadiusControlGui];
}

/*
 * Calculate areas on the canvas where movable views are not allowed
 */
-(CGRect)keepOutZones;
{
    CGRect segmentedControlFrame = self.backgroundColorControl.frame;
    CGRect sliderFrame = self.cornerRadiusControl.frame;
    CGRect frame =  CGRectUnion(segmentedControlFrame, sliderFrame);
    return CGRectInset(frame, -25, -25); // add a buffer around frames
                                         // not the best way, just a quick hack
                                         // also not perfect in rotation
}


#pragma mark - Corner Radius methods
/*
 * Update the corner radius control slider gui based on the NSUserDefault value
 */
-(void) updateCornerRadiusControlGui;
{
    NSNumber* value = [[NSUserDefaults standardUserDefaults]
                       objectForKey:kUserDefaultCorderRadius];
    CGFloat sliderValue = [value floatValue];
    self.cornerRadiusControl.value = sliderValue;
}

 /*
  * Called when the user changes the slider control value
  */
-(void)chooseCornerRadius:(UISlider*)sender;
{
    CGFloat sliderValue = sender.value;
    [[NSUserDefaults standardUserDefaults] setObject:@(sliderValue)
                                              forKey:kUserDefaultCorderRadius];
}


#pragma mark - Tap Gesture Recognizer

/*
 * Called when the user taps on the screen
 */
-(void)tapped:(UITapGestureRecognizer*)tapGesture
{
    CGPoint center = [tapGesture locationInView:self.view];
    
    if ( CGRectContainsPoint([self keepOutZones], center))
    {
        return;
    }
    
    if (tapGesture.state == UIGestureRecognizerStateRecognized)
    {
        [MovableView addToViewController:self atCenter:center];
    }
}

#pragma mark - Segmented Control Action Methods
/*
 *  Called when user changes color via segmented control, updates NSUserDefaults
 */
-(void)chooseBackgroundColor:(UISegmentedControl*)sender
{
    NSInteger index = sender.selectedSegmentIndex;
    [[NSUserDefaults standardUserDefaults] setObject:[MovableView movableViewColors][index]
                                              forKey:kUserDefaultBackgroundColor];
}

/*
 * Called by updateGui when the NSUserDefaults has changed. Updates the segmented control
 */
-(void)updateBackgroundControlGui
{    
    NSArray* colors = [MovableView movableViewColors];
    NSString* userDefaultBackgroundColor =
        [[NSUserDefaults standardUserDefaults]
            objectForKey:kUserDefaultBackgroundColor];
    NSInteger index = [colors indexOfObject:userDefaultBackgroundColor];
    [self.backgroundColorControl setSelectedSegmentIndex:index];
    
}



@end
