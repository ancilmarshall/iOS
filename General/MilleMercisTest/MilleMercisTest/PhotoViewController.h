//
//  PhotoViewController.h
//  MilleMercisTest
//
//  Created by Ancil on 9/9/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController
@property (nonatomic,strong) NSURL* url;
@property (nonatomic,strong) NSString* imageTitle;

-(void)setImage:(UIImage*)image;

@end
