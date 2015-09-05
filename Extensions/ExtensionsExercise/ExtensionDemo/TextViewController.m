//
//  ViewController.m
//  ExtensionDemo
//
//  Created by Tim Ekl on 2015.02.15.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "TextViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface TextViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TextViewController

- (IBAction)actionText:(id)sender {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[ self.textView.text ] applicationActivities:nil];
    activityVC.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if (!completed) {
            return;
        }
        
        for (NSExtensionItem *extensionItem in returnedItems) {
            for (NSItemProvider *itemProvider in extensionItem.attachments) {
                if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeText]) {
                    [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeText options:nil completionHandler:^(NSString *text, NSError *error) {
                        self.textView.text = text;
                    }];
                }
            }
        }
    };
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
