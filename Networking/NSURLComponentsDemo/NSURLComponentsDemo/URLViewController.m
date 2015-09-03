//
//  ViewController.m
//  NSURLComponentsDemo
//
//  Created by Tim Ekl on 2015.02.11.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "URLViewController.h"

@interface NSString (StringValue)
- (NSString *)stringValue;
@end

@implementation NSString (StringValue)

- (NSString *)stringValue;
{
    return self;
}

@end

@interface URLViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *URLField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSURLComponents *URLComponents;

@end

@implementation URLViewController

- (void)setURLComponents:(NSURLComponents *)URLComponents;
{
    _URLComponents = [URLComponents copy];
    [self.tableView reloadData];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSString *URLString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.URLComponents = [NSURLComponents componentsWithString:URLString];
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    switch (section) {
        case 0: return [[self URLComponentPropertyNames] count];
        case 1: return [[self.URLComponents queryItems] count];
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        // URL component value
        NSString *propertyName = [self URLComponentPropertyNames][indexPath.row];
        cell.textLabel.text = [propertyName capitalizedString];
        
        if (self.URLComponents != nil) {
            cell.detailTextLabel.text = [[self.URLComponents valueForKey:propertyName] stringValue];
        } else {
            cell.detailTextLabel.text = @"(nil)";
        }
        
    } else if (indexPath.section == 1) {
        
        // Query value
        NSURLQueryItem *queryItem = [self.URLComponents queryItems][indexPath.row];
        cell.textLabel.text = [queryItem name];
        cell.detailTextLabel.text = [queryItem value];
        
    } else {
        NSAssert(false, @"Unknown section index");
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    switch (section) {
        case 0: return NSLocalizedString(@"Components", nil);
        case 1: return NSLocalizedString(@"Query", nil);
        default: return nil;
    }
}

#pragma mark - Private

- (NSArray *)URLComponentPropertyNames;
{
    return @[ @"scheme", @"host", @"port", @"path" ];
}

@end
