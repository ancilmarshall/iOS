//
//  ViewController.m
//  UW_HW5_Ancil
//
//  Created by Ancil on 12/11/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "ViewController.h"
#import "GeocoderTableViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate,
    GeocoderTVCDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic,assign) BOOL newAnnotationSet;
@property (nonatomic,strong) MKPointAnnotation* annotation;
@end
@implementation ViewController

- (void) viewDidLoad
{
    //explicitly initialize the newAnnotationSet to NO
    self.newAnnotationSet = NO;
    
    //let's try authorizing location services and enabling mapView immediately
    // during viewDidLoad instead of waiting for viewDidAppear. Found that
    // sometimes I was not tracking the current user location immediately
    if ([self verifyLocationServicesAuthorization])
    {
        self.mapView.showsUserLocation = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //check if the newAnnotationSet flag is true, if so, drop the new pin
    if (self.newAnnotationSet){
        self.newAnnotationSet = NO;
        [self.mapView addAnnotation:self.annotation];
        self.annotation = nil;
    }
    
    [self userPushedFindMe:nil]; //always track the user
}

#pragma mark - Action methods

- (IBAction)userPushedCheckIn:(UIBarButtonItem *)sender;
{
    if ([self verifyLocationServicesAuthorization])
    {
        CLLocation* currentLocation = [self currentUserLocation];
        
        UINavigationController* navController = [UINavigationController new];
        GeocoderTableViewController* gtvc = [GeocoderTableViewController new];
        gtvc.delegate = self;
        gtvc.location = currentLocation;
        
        [navController addChildViewController:gtvc];
        [self presentViewController:navController animated:YES completion:nil];
    }
}

- (IBAction)userPushedFindMe:(UIBarButtonItem*)sender;
{
    
    if ([self verifyLocationServicesAuthorization])
    {
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }
}

#pragma mark - GeocoderTableViewControllerDelegate
- (void)geocoderTableViewController:(GeocoderTableViewController*)sender
                 didSelectPlacemark:(CLPlacemark*)placemark;
{

    //verify that sender is the expected geocoderTVC controller on the nav stack
    id currentGTVC = [[self.presentedViewController childViewControllers]
                        firstObject];
    NSAssert([currentGTVC isKindOfClass:[GeocoderTableViewController class]],
             @"Expected a GeocoderTableViewController");
    
    NSAssert( sender == (GeocoderTableViewController*)currentGTVC ,
             @"Expected sender to be my attached GeocoderTableViewController");
    
    //create and update an annotation based on the placemark geocoder data
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = placemark.location.coordinate;
    annotation.title = placemark.name;
    annotation.subtitle = [NSString stringWithFormat:@"%@/%@",
                           placemark.locality,placemark.administrativeArea];
    
    self.annotation = annotation;
    self.newAnnotationSet = YES; //set this flag here to indicate a new annotation available
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didChangeAuthorizationStatus:(CLAuthorizationStatus)status;
{
    [self verifyLocationServicesAuthorization];
}

#pragma mark - MapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation;
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    //get the MKPinAnnotationView from the reusable queue
    static NSString *reuseIdentifier = @"annotationView";
    MKAnnotationView *annotationView = [self.mapView
                dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    
    //create an MKPinAnnotation if necessary
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc]
                          initWithAnnotation:annotation
                            reuseIdentifier:reuseIdentifier];
    }
    
    NSAssert([annotationView isKindOfClass:[MKPinAnnotationView class]],
             @"Expected custom annotations to be pins");
    MKPinAnnotationView *pin = (MKPinAnnotationView *)annotationView;
    
    //update the pin annotation view paramters
    pin.canShowCallout = YES;
    pin.pinColor = MKPinAnnotationColorPurple;
    pin.animatesDrop = YES;
    
    return pin;
}

#pragma mark - Helpers
//get the current user location directly from the MKMapView object
- (CLLocation*) currentUserLocation;
{
    MKUserLocation *userLocationAnnotation = [self.mapView userLocation];
    CLLocation* location = [userLocationAnnotation location];
    return location;
}

//helper function to verify location services
- (BOOL)verifyLocationServicesAuthorization;
{
    //if not available globally via the hardware of the global settings
    if (![CLLocationManager locationServicesEnabled]) {
        return NO;
    }
    
    switch ([CLLocationManager authorizationStatus])
    {
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            return NO;
            
        case kCLAuthorizationStatusNotDetermined:
            if (self.locationManager == nil)
            {
                self.locationManager = [[CLLocationManager alloc] init];
                self.locationManager.delegate = self;
                [self.locationManager requestWhenInUseAuthorization];
            }
            return NO;
            
            //otherwise break out of switch and return YES below
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            break;
    }
    
    return YES;
}


@end
