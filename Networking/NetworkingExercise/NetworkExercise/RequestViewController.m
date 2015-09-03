//
//  ViewController.m
//  NetworkExercise
//
//  Created by Tim Ekl on 2015.02.11.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "RequestViewController.h"

NSString* ResponseViewDataNotificationName = @"ResponseViewDataNotificationName";
NSString* ResponseViewHTTPURLHeadersNotificationName = @"ResponseViewHTTPURLHeadersNotificationName";

@interface RequestViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *requestURLField;
@property (weak, nonatomic) IBOutlet UIPickerView *requestTypePicker;
@property (strong, nonatomic) NSURLSession* session;

@property (weak, nonatomic) NSString *selectedHTTPRequestMethod;

@end

@implementation RequestViewController

- (IBAction)sendNetworkRequest:(id)sender {
    // TODO #1: construct a request for the URL in the requestURLField using the selected HTTP request method and send it using NSURLSession APIs
    NSURL* URL = [NSURL URLWithString:self.requestURLField.text];
    if (nil != URL){
        
        //Note how the session is cached so as to not create new ones each time
        // this function is run
        if (self.session == nil){
            NSURLSessionConfiguration* config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
            self.session = [NSURLSession sessionWithConfiguration:config];
        }
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
        request.HTTPMethod = self.selectedHTTPRequestMethod;
        
        NSURLSessionDataTask* task = [self.session dataTaskWithRequest:request
                                      
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (data == nil) {
                    NSLog(@"Error loading data: %@", error);
                    return;
                }
                
                NSStringEncoding enc = [self stringEncodingWithName:[response textEncodingName]];
                NSString *dataString = [[NSString alloc] initWithData:data encoding:enc];

                [[NSNotificationCenter defaultCenter]
                    postNotificationName:ResponseViewDataNotificationName
                                  object:dataString];
                
                NSAssert([response isKindOfClass:[NSHTTPURLResponse class]],@"");
                NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                
                NSDictionary* httpHeaders = httpResponse.allHeaderFields;
                
                [[NSNotificationCenter defaultCenter]
                    postNotificationName:ResponseViewHTTPURLHeadersNotificationName
                                  object:httpHeaders];
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
            }];

        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [task resume];
    }
}

- (NSString *)selectedHTTPRequestMethod;
{
    NSInteger selectedRow = [self.requestTypePicker selectedRowInComponent:0];
    return [self supportedHTTPRequestMethods][selectedRow];
}

- (void)setSelectedHTTPRequestMethod:(NSString *)selectedHTTPRequestMethod;
{
    NSInteger index = [[self supportedHTTPRequestMethods] indexOfObject:selectedHTTPRequestMethod];
    [self.requestTypePicker selectRow:index inComponent:0 animated:YES];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [[self supportedHTTPRequestMethods] count];;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [self supportedHTTPRequestMethods][row];
}

#pragma mark - Private

- (NSArray *)supportedHTTPRequestMethods;
{
    return @[ @"GET", @"POST" ];
}

- (NSStringEncoding)stringEncodingWithName:(NSString *)name;
{
    CFStringEncoding enc = CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)name);
    return CFStringConvertEncodingToNSStringEncoding(enc);
}

@end
