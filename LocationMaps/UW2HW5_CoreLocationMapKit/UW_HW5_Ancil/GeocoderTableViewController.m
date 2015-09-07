//
//  GeocoderTableViewController.m
//  UW_HW5_Ancil
//
//  Created by Ancil on 12/11/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "GeocoderTableViewController.h"

#pragma mark - Private Custom TableViewCell inorder to override the cell style
@interface MyTableViewCell : UITableViewCell
@end

@implementation MyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:reuseIdentifier];
    return self;
}
@end

static NSString* const kCellIdentifier = @"tableViewCell";

@interface GeocoderTableViewController ()
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, assign) BOOL geocodingActive;
@property (nonatomic, strong) NSArray* placemarks;
@end

@implementation GeocoderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.geocoder == nil) {
        self.geocoder = [[CLGeocoder alloc] init];
        self.geocodingActive = NO;
    }
    
    // make sure that only one geocoding request at a time is taking place
    if (self.geocodingActive == NO) {
        self.geocodingActive = YES;
        [self.geocoder reverseGeocodeLocation:self.location
                            completionHandler:^(NSArray *placemarks, NSError *error) {
                                if (error != nil) {
                                    NSLog(@"geo location error");
                                    return;
                                }
                                self.placemarks = placemarks;
                                self.geocodingActive = NO;
                                [self.tableView reloadData];
                            }];
    }
    
    //setup table view cell with reuse identifier
    [self.tableView registerClass:[MyTableViewCell class]
           forCellReuseIdentifier:kCellIdentifier];
    
    //setup navigation bar stuff
    UIBarButtonItem* cancelButton =
        [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
            target:self
            action:@selector(geocodingCancelled:)];

    self.navigationItem.title = @"Loading";
    self.navigationItem.rightBarButtonItem = cancelButton;
    
}

- (void) geocodingCancelled:(UIBarButtonItem*)sender;
{
    [self.geocoder cancelGeocode];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    if ( self.placemarks == nil )
        count = 1; //TODO: show the spinning wheel that the table is loaded instead
    else count = [self.placemarks count];
    
    return count;
}

- (MyTableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTableViewCell *cell = [tableView
        dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    CLPlacemark* placemark = self.placemarks[indexPath.row];
    cell.textLabel.text = placemark.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/%@",
                                 placemark.locality,
                                 placemark.administrativeArea];
    
    return cell;
}


#pragma mark - Table View Delegate
// here use the GeocoderTVCDelegate to report back to the ViewController when
// a placemark is chosen
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLPlacemark* placemark = self.placemarks[indexPath.row];
    NSAssert(self.delegate != nil,@"Geocoder Table View Controller delegate must be set");
    [self.delegate geocoderTableViewController:self didSelectPlacemark:placemark];
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
