//
//  HW4AddBirthdayViewController.m
//  UW_HW4_Ancil
//
//  Created by Ancil on 12/13/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "HW4AddBirthdayViewController.h"
#import "BirthdayData.h"

static const CGFloat kDefaultToolBarHeight = 44.0f;

@interface HW4AddBirthdayViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* toolbarHeightConstraint;

@end

@implementation HW4AddBirthdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    
    //NOTE: for some reason, could put this in a navigation controller and
    //get the benefit of the correct height. So adjusting manually based on the
    //status bar height. Using constraints here, which was a life-saver.
    CGFloat statusBarHeight =
        [UIApplication sharedApplication].statusBarFrame.size.height;
    self.toolbarHeightConstraint.constant = kDefaultToolBarHeight + statusBarHeight;
    
    [self.firstNameTextField becomeFirstResponder];
}

#pragma mark - User actions
- (IBAction)userClickedDone:(id)sender;
{
    NSString* fname = self.firstNameTextField.text;
    NSString* lname = self.lastNameTextField.text;
    NSDate* date = self.datePicker.date;
    
    //input validation
    if ( fname.length == 0 && lname.length==0 ) {
        [self showAlert];
        return;
    }

    [[BirthdayData sharedInstance] addFirstName:fname lastName:lname birthday:date];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)userClickedCancel:(id)sender;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// show alert if first or last name is empty
- (void) showAlert
{
    UIAlertController* alertController = [UIAlertController
                                          alertControllerWithTitle:@"Missing name"
                                          message:@"Please enter first or last name"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                     }];
    
    [alertController addAction:okAction];
    [alertController setModalPresentationStyle:UIModalPresentationNone];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //dismiss the keyboard when the enter button is hit
    if (textField == self.firstNameTextField){
        [self.firstNameTextField resignFirstResponder];
    }
    else if (textField == self.lastNameTextField){
        [self.lastNameTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Rotation
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    //use the coordinator block function to get immediately the value of
    //the status bar height at the point when the rotation will be completed
    [coordinator animateAlongsideTransition:
     ^(id<UIViewControllerTransitionCoordinatorContext> context) {
         CGFloat statusBarHeight =
            [UIApplication sharedApplication].statusBarFrame.size.height;
         self.toolbarHeightConstraint.constant = kDefaultToolBarHeight + statusBarHeight;
     }
    completion:nil];
    
}

@end
