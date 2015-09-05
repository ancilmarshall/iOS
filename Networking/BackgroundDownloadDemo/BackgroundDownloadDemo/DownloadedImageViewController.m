//
//  ViewController.m
//  BackgroundDownloadDemo
//
//  Created by Tim Ekl on 2015.02.09.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "DownloadedImageViewController.h"
#import "AppDelegate.h"

@interface DownloadedImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DownloadedImageViewController

- (IBAction)downloadImage:(id)sender {
    [[AppDelegate delegate] beginBackgroundDownload];
}

// these are just wrapper functions or proxy functions to the imageView from the image property
- (UIImage *)image;
{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image;
{
    self.imageView.image = image;
}

@end
