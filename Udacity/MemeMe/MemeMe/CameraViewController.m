//
//  CameraViewController.m
//  UW_HW6_Ancil
//
//  Created by Ancil on 12/16/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "CameraViewController.h"
#import "PhotoTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *topInput;
@property (weak, nonatomic) IBOutlet UITextField *bottomInput;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CameraViewController

#pragma mark - view life cycle and rotation

static NSUInteger topInputKVOContext;
static NSUInteger bottomInputKVOContext;
static NSUInteger imageViewKVOContext;

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Camera";
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonPressed)];
    
    UIBarButtonItem* postButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(postButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
    self.navigationItem.leftBarButtonItem = postButton;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    self.topInput.delegate = self;
    self.bottomInput.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:)name: UIKeyboardWillShowNotification object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name: UIKeyboardWillHideNotification object: nil];
    
    [self addObserver:self
           forKeyPath:@"topInput.text"
              options:NSKeyValueObservingOptionNew
              context:&topInputKVOContext];

    [self addObserver:self
           forKeyPath:@"bottomInput.text"
              options:NSKeyValueObservingOptionNew
              context:&bottomInputKVOContext];
    
    [self addObserver:self
           forKeyPath:@"imageView.image"
              options:NSKeyValueObservingOptionNew
              context:&imageViewKVOContext];
    

}

- (IBAction)takePhoto:(UIBarButtonItem*)sender;
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = @[ (__bridge NSString *)kUTTypeImage ];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)showPhotoAlbum:(UIBarButtonItem *)sender {
    
    PhotoTableViewController* photoTableViewController = [PhotoTableViewController new];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:photoTableViewController];
    [self presentViewController:navController animated:YES completion:nil];
    
}

- (void)cancelButtonPressed;
{
    [self.topInput resignFirstResponder];
    [self.bottomInput resignFirstResponder];
    
    self.topInput.text = @"TOP";
    self.bottomInput.text = @"BOTTOM";
    self.imageView.image = nil;
    
}

-(void)postButtonPressed;
{
    
    //capture the imageview only
    UIGraphicsBeginImageContext(self.imageView.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //Post only if the Meme is non-nil
    if (self.imageView.image != nil && self.topInput.text != nil && self.bottomInput.text !=nil) {

        if ( [self.topInput.text isEqualToString:@"TOP"] ||
            [self.bottomInput.text isEqualToString:@"BOTTOM"]) {
            [self showAlert:kIncorrectMemeLabels];
        }
        
        
        
        UIActivityViewController* activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
        
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    
}

- (void)keyboardWillAppear:(NSNotification*)notification;
{
    
    NSDictionary* userInfo = notification.userInfo;
    double animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    
    if ( self.bottomInput.editing ) {
    
        [UIView animateWithDuration:animationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
                             CGRect newFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, screenHeight - height);
                             self.view.frame = newFrame;
                             [self.view setNeedsLayout];
                             [self.view layoutIfNeeded];
                             
                         } completion:nil];
    }
}

- (void)keyboardWillDisappear:(NSNotification*)notification;
{
    NSDictionary* userInfo = notification.userInfo;
    double animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
                         CGRect newFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, screenHeight);
                         self.view.frame = newFrame;
                         [self.view setNeedsLayout];
                         [self.view layoutIfNeeded];
                         
                     } completion:nil];
}

#pragma mark - UITextFieldDelegate

-(void) textFieldDidBeginEditing:(UITextField *)textField;
{
    
}

-(void) textFieldDidEndEditing:(UITextField *)textField;
{
    if ( [textField.text isEqualToString:@""] ||
         [textField.text isEqualToString:@"TOP"] ||
        [textField.text isEqualToString:@"BOTTOM"]) {
        
        [self showAlert:kIncorrectMemeLabels];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    
    if ( textField == self.topInput) {
        self.topInput.text = self.topInput.text;
        if ( [self.topInput.text isEqualToString:@""] )
            self.topInput.text = @"TOP";
    }
    
    if ( textField == self.bottomInput ) {
        
        self.bottomInput.text = self.bottomInput.text;
        if ( [self.bottomInput.text isEqualToString:@""])
            self.bottomInput.text = @"BOTTOM";
    }

    
    return YES;
}


#pragma mark - UIImagePickerControllerDelegate

//dismiss the view controller if the use cancels the camera picker (cancel button is part of GUI)
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//if user takes photo, unpack photo data from the NSDictionary parameter
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    NSAssert(UTTypeConformsTo((__bridge CFStringRef)mediaType, kUTTypeImage), @"Expected an image type");
    
    //grab either the edited (by user within the camera app) or the original photo
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    //save to the device's photo library and update the UI before dismissing
    if (image != nil) {
        UIImageWriteToSavedPhotosAlbum(image, nil, NULL, NULL);
        self.imageView.image = image;
    }
    
    //dismiss the controller after the image has been updated
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void) setImage:(UIImage*)image;
{
    self.imageView.image = image;
}


# pragma mark - KVO Observation
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    // Can't unconditionally call super here! Would throw when handling an unexpected keyPath
    //    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    // Instead, check the context for a match against our private static integer
    if (!((context == &topInputKVOContext) ||
        (context == &bottomInputKVOContext) ||
        (context == &imageViewKVOContext)))
    {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    // From this point on, guaranteed that all KVO calls are ones that this class registered for
    NSParameterAssert(object == self);
    
    if ([keyPath isEqualToString:@"topInput.text"]){
        //NSLog(@"topInput.text");
        if (![self.bottomInput.text isEqualToString:@"BOTTOM"] &&
            ![self.topInput.text isEqualToString:@"TOP"] &&
            self.imageView.image != nil )
        {
            self.navigationItem.leftBarButtonItem.enabled = YES;
        }
        
    } else if ([keyPath isEqualToString:@"bottomInput.text"]){
        //NSLog(@"bottomInput.text");
        if (![self.bottomInput.text isEqualToString:@"BOTTOM"] &&
            ![self.topInput.text isEqualToString:@"TOP"] &&
            self.imageView.image != nil )
        {
            self.navigationItem.leftBarButtonItem.enabled = YES;
        }
        
    } else if ([keyPath isEqualToString:@"imageView.image"]){
        //NSLog(@"imageView.image");
        if (![self.bottomInput.text isEqualToString:@"BOTTOM"] &&
            ![self.topInput.text isEqualToString:@"TOP"] &&
            self.imageView.image != nil )
        {
            self.navigationItem.leftBarButtonItem.enabled = YES;
        }
        
    } else {
        NSLog(@"KVO Error");
    }
}

#pragma mark - Alert Controller
static NSString* const kIncorrectMemeLabels = @"IncorrectLabels";

- (void) showAlert:(NSString*)errMsg
{
    //instantiate an empty alertController here. Fill in data depending on errMsg
    UIAlertController* alertController = [UIAlertController
                                          alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    if ([errMsg isEqualToString:kIncorrectMemeLabels])
    {
        alertController.title = @"Incorrect Meme Headlines";;
        alertController.message =  @"Please change Meme labels";
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                         }];
        
        [alertController addAction:okAction];
        
    }
    
    [alertController setModalPresentationStyle:UIModalPresentationNone];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
