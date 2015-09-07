//
//  ViewController.m
//  UW_HW2_Ancil
//
//  Created by Ancil on 10/10/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "CustomView.h"
#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) CustomView* redView;
@property (nonatomic,strong) CustomView* blueView;
@property (nonatomic,strong) NSLayoutConstraint* redTopConstraint;
@property (nonatomic,strong) NSLayoutConstraint* redHeightConstraint;
@property (nonatomic,strong) NSLayoutConstraint* redWidthConstraint;
@property (nonatomic,strong) NSLayoutConstraint* blueBottomConstraint;
@property (nonatomic,strong) NSLayoutConstraint* blueHeightConstraint;
@property (nonatomic,strong) NSLayoutConstraint* blueWidthConstraint;
@property (nonatomic,strong) UISlider* slider;
@property (nonatomic,assign) CGSize viewSize; //holds size while rotating
@end

@implementation ViewController

//constants
const CGFloat kRedBlueViewSpace = 10.0f;
const CGFloat kViewMargin = 10.0f;

//typedefs
typedef enum {TOTAL,FIXED} Length_Type;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.viewSize = self.view.bounds.size;
    
    //set up UI elements, redView, blueView and slider
    UINib *redNib = [UINib nibWithNibName:@"CustomView" bundle:[NSBundle mainBundle]];
    self.redView = [redNib instantiateWithOwner:self options:nil][0];
    self.redView.titleLabel.text = @"Red View";
    self.redView.backgroundColor = [UIColor redColor];
    self.redView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.redView];
    
    UINib *blueNib = [UINib nibWithNibName:@"CustomView" bundle:[NSBundle mainBundle]];
    self.blueView = [blueNib instantiateWithOwner:self options:nil][0];
    self.blueView.titleLabel.text = @"Blue View";
    self.blueView.backgroundColor = [UIColor blueColor];
    self.blueView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.blueView];
    
    self.slider = [UISlider new];
    self.slider.value = 0.5;
    self.slider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.slider addTarget:self
                   action:@selector(sliderValueChanged:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    [self initializeConstraints];
}

// initially waits till this lifecyle to make sure that topLayoutGuide is set
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self updateConstraintConstants];
}

/*
 * By setting up the constraints as follows, all the constraints are always active
 * Only their constants change. This set up fixes the red view's top constraint 
 * and varies it's left, height and width constraint. The blue view's bottom constraint
 * is fixed, but its right, height and width constraints are varied based on orientation
 * and slider value.
 */
-(void)initializeConstraints
{
    //set up the slider constraints. Used this format to get edge of self.view
    // and not the view's margin if using the visual format
    [NSLayoutConstraint constraintWithItem:self.slider
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:kViewMargin].active = YES;
    
    // notice the negative sign needed due to order of constraint setup
    [NSLayoutConstraint constraintWithItem:self.slider
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:-kViewMargin].active = YES;

    // notice the negative sign needed due to order of constraint setup
    [NSLayoutConstraint constraintWithItem:self.slider
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.bottomLayoutGuide
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:-kViewMargin].active = YES;
    
    // red View left constraint (always fixed)
    [NSLayoutConstraint constraintWithItem:self.redView
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:kViewMargin].active = YES;
    
    // red view top constraint (changes based on orientation)
    self.redTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.redView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:0];
    self.redTopConstraint.active = YES;

    // red view width constraint (changes based on orientation)
    self.redWidthConstraint =
    [NSLayoutConstraint constraintWithItem:self.redView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:0
                                  constant:0];
    self.redWidthConstraint.active = YES;
    
    //red view height constraint (changes based on orientation)
    self.redHeightConstraint =
    [NSLayoutConstraint constraintWithItem:self.redView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:0
                                  constant:0];
    self.redHeightConstraint.active = YES;
    
    //blue view right constraint (always fixed). Note negative sign in constant
    [NSLayoutConstraint constraintWithItem:self.blueView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:-kViewMargin].active = YES;
    
    // blue view bottom constraint (changes based on orientation)
    self.blueBottomConstraint =
    [NSLayoutConstraint constraintWithItem:self.blueView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0];
    self.blueBottomConstraint.active = YES;
    
    // blue view width constraint (chagnes based on orientation)
    self.blueWidthConstraint =
    [NSLayoutConstraint constraintWithItem:self.blueView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:0
                                  constant:0];
    self.blueWidthConstraint.active = YES;
    
    // blue view height constraint (chagnes based on orientation)
    self.blueHeightConstraint =
    [NSLayoutConstraint constraintWithItem:self.blueView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:0
                                  constant:0];
    self.blueHeightConstraint.active = YES;
    
}

/*
 * Constraint constants need updating during rotation transition
 */
-(void)updateConstraintConstants
{
    // note the required negative sign
    self.redTopConstraint.constant = [self topContsraintConstant];
    self.blueBottomConstraint.constant = -[self bottomConstraintConstant];
    
    CGFloat redConstant;
    CGFloat blueConstant;
    [self calcVariableDimensionsRed:&redConstant blue:&blueConstant];
    
    if ([self isPortrait])
    {
        self.redWidthConstraint.constant = [self getLength:FIXED];
        self.redHeightConstraint.constant = redConstant;
        self.blueWidthConstraint.constant = [self getLength:FIXED];
        self.blueHeightConstraint.constant = blueConstant;
    }
    else
    {
        self.redWidthConstraint.constant =  redConstant;
        self.redHeightConstraint.constant = [self getLength:FIXED];
        self.blueWidthConstraint.constant = blueConstant;
        self.blueHeightConstraint.constant = [self getLength:FIXED];
    }
}

#pragma mark - Variable length/height/width calculations based on orientation

/*
 * Calculation that returns the variable length of the views based on slider
 */
- (void) calcVariableDimensionsRed:(CGFloat*)redDimension
                              blue:(CGFloat*)blueDimension
{
    CGFloat alpha = [self.slider value];
    CGFloat length = [self getLength:TOTAL];
    CGFloat redDim;
    CGFloat blueDim;
    
    if ( alpha > 0.0 && alpha < 1.0 )
    {
        redDim = alpha * length - kRedBlueViewSpace/2.0;
        blueDim = (1.0 - alpha)* length - kRedBlueViewSpace/2.0;
        
    }
    else if (alpha == 1.0)
    {
        redDim = length;
        blueDim = 0.0;
    }
    else // alpha == 0.0
    {
        redDim = 0.0;
        blueDim = length;
    }

    //because of space between views, the calculation falls negative as as
    // alpha approaches 0.0 and 1.0. Capping them here is an easy solution
    if (blueDim < 0.0) {
        blueDim = 0.0;
    }
    if (redDim < 0.0) {
        redDim = 0.0;
    }
    
    *redDimension = redDim;
    *blueDimension = blueDim;
}

/*
 * Return value from view's top edge to top of red (or blue in landscape) view
 */
-(CGFloat)topContsraintConstant
{
    CGFloat length = self.topLayoutGuide.length;
    if (length == 0) // as in the case of landscape for iPhone
    {
        length = kViewMargin;
    }
    return length;
}

/*
 * Return value from view's bottom edge to the bottom edge of blue (or red) view
 */
-(CGFloat)bottomConstraintConstant
{
    return kViewMargin+self.slider.bounds.size.height;
}

/*
 * Calculate the desired length based on lengthType parameter
 * TOTAL implies the total length of the longest dimension, ie. along the axis
 *  that varies based on the slider value. This is the total length of the red
 *  and blue views and the space between them along the varying axis
 *
 * FIXED implies the length that does not change and is the same in the red and
 *  blue views, e.g. their width in Portrait mode.
 */
-(CGFloat)getLength:(Length_Type)lengthType
{
    CGFloat length;
    
    //total length in Portrait, fixed length landscape
    if ( ([self isPortrait]  && lengthType == TOTAL)  ||
         ([self isLandscape] && lengthType == FIXED))
    {
        length = self.viewSize.height -
                 [self topContsraintConstant] -
                 [self bottomConstraintConstant];
    }
    //total length landscape or fixed length portrait
    else if ( ([self isLandscape] && lengthType == TOTAL)  ||
              ([self isPortrait]  && lengthType == FIXED))
    {
        length = self.viewSize.width -
                 2*kViewMargin;
    }
    
    return length;
}

/*
 * selector called when the slider is changed
 */
- (void)sliderValueChanged:(UISlider *)sender
{
    [self updateConstraintConstants];
    [self.view layoutIfNeeded];
}

/*
 * override this method to perform calculations during rotation
 */
- (void)viewWillTransitionToSize:(CGSize)size
withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size
          withTransitionCoordinator:coordinator];
    
    self.viewSize = size;
    [self updateConstraintConstants];

    [coordinator animateAlongsideTransition:
                ^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - helper functions

- (BOOL)isPortrait
{
    return self.viewSize.height >= self.viewSize.width;
}

- (BOOL)isLandscape
{
    return ![self isPortrait];
}

@end
