//
//  CameraViewController.m
//  UW_HW6_Ancil
//
//  Created by Ancil on 12/16/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* tabBarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* navBarHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton* takePhotoButton;
@end

@implementation CameraViewController

#pragma mark - initialization and rotation

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Camera";
    self.takePhotoButton.layer.cornerRadius = self.takePhotoButton.frame.size.height * 0.45;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateConstraints];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:
    (id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    //use the coordinator block function to get immediately the height value
    [coordinator animateAlongsideTransition:
     ^(id<UIViewControllerTransitionCoordinatorContext> context) {
         [self updateConstraints];
     }
    completion:nil];
}

- (void) updateConstraints
{
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    self.tabBarHeightConstraint.constant = tabBarHeight + 8.0f;
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    self.navBarHeightConstraint.constant = navBarHeight + 8.0f;
}

- (IBAction)takePhoto:(id)sender;
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

@end
