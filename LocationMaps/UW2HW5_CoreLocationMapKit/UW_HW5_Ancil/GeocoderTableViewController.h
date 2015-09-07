//
//  GeocoderTableViewController.h
//  UW_HW5_Ancil
//
//  Created by Ancil on 12/11/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLLocation;
@class CLPlacemark;
@protocol GeocoderTVCDelegate;

@interface GeocoderTableViewController : UITableViewController
@property (nonatomic,weak) CLLocation* location;
@property (nonatomic,weak) id<GeocoderTVCDelegate> delegate;
@end

@protocol GeocoderTVCDelegate <NSObject>
-(void)geocoderTableViewController:(GeocoderTableViewController*)sender
                didSelectPlacemark:(CLPlacemark*)placemark;
@end
