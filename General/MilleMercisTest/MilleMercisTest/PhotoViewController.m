//
//  PhotoViewController.m
//  MilleMercisTest
//
//  Created by Ancil on 9/9/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "PhotoViewController.h"
#import "AppDelegate.h"

@interface PhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activity startAnimating];

    self.navigationItem.title = self.imageTitle;
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    
    
    AppDelegate* appDelegate = [AppDelegate delegate];
    [appDelegate viewController:self beginBackgroundDownloadForURL:self.url];
    
}

-(void)viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
    [self setImage:nil];
}

-(void)setImage:(UIImage *)image;
{
    [self.activity stopAnimating];
    self.imageView.image = image;
}

@end
