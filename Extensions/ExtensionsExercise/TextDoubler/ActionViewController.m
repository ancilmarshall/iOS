//
//  ActionViewController.m
//  TextDoubler
//
//  Created by Tim Ekl on 2015.02.15.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <TextChangerKit/TextChangerKit.h>

@interface ActionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get the item[s] we're handling from the extension context.
    // Look for text and place it into the text view.
    BOOL textFound = NO;
    
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeText]) {
                // This is text. We'll load it, then place it in our text view.
                __weak UITextView *textView = self.textView;
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeText options:nil completionHandler:^(NSString *text, NSError *error) {
                    if (text != nil) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [textView setText:text];
                        }];
                    }
                }];
                
                textFound = YES;
                break;
            }
        }
        
        if (textFound) {
            // We only handle one piece of text, so stop looking for more.
            break;
        }
    }
}

- (IBAction)done {
    // Return any edited content to the host app.
    NSExtensionItem *editedItem = [[NSExtensionItem alloc] init];
    editedItem.attachments = @[ [[NSItemProvider alloc] initWithItem:self.textView.text typeIdentifier:(NSString *)kUTTypeText] ];
    [self.extensionContext completeRequestReturningItems:@[ editedItem ] completionHandler:nil];
}

#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [[TextChanger allChangers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"changerCell" forIndexPath:indexPath];
    cell.textLabel.text = [[TextChanger allChangers][indexPath.row] actionTitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TextChanger *changer = [TextChanger allChangers][indexPath.row];
    self.textView.text = [changer changeText:self.textView.text];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
