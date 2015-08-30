//
//  ViewController.m
//  NetworkDemo
//
//  Created by Tim Ekl on 2015.02.03.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "NetworkViewController.h"

@interface NetworkViewController ()

@property (weak, nonatomic) IBOutlet UITextField *URLTextField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation NetworkViewController

- (IBAction)sendRequest:(id)sender {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:[self.URLTextField text]];
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data == nil) {
            NSLog(@"Error loading data: %@", error);
            return;
        }
        
        NSStringEncoding enc = [self stringEncodingWithName:[response textEncodingName]];
        NSString *dataString = [[NSString alloc] initWithData:data encoding:enc];
        [self.webView loadHTMLString:dataString baseURL:URL];
    }];
    [task resume];
}

- (NSStringEncoding)stringEncodingWithName:(NSString *)name;
{
    CFStringEncoding enc = CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)name);
    return CFStringConvertEncodingToNSStringEncoding(enc);
}

@end
