//
//  ViewController.m
//  UWHWKeychain
//
//  Created by Tim Ekl on 11/11/14.
//  Copyright (c) 2014 Tim Ekl. All rights reserved.
//

#import "DetailsViewController.h"
#import "ListViewController.h"

static NSString * const ListViewControllerAddKeychainItemSegueIdentifier = @"addKeychainItemSegue";
static NSString * const ListViewControllerEditKeychainItemSegueIdentifier = @"editKeychainItemSegue";

@interface ListViewController ()

@property (nonatomic, strong) NSArray *keychainItems;

@end

@implementation ListViewController

#pragma mark - UIViewController subclass

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    [self refetchData];
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
{
    // We only have these two segues, so unconditionally do the assertion & cast
    NSAssert([segue.destinationViewController isKindOfClass:[DetailsViewController class]], @"Expected a details controller when dealing with a keychain item");
    DetailsViewController *detailsController = (DetailsViewController *)segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:ListViewControllerAddKeychainItemSegueIdentifier]) {
        [detailsController showDetailsForItemAttributes:nil];
    } else if ([segue.identifier isEqualToString:ListViewControllerEditKeychainItemSegueIdentifier]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [detailsController showDetailsForItemAttributes:self.keychainItems[indexPath.row]];
    }
}

- (IBAction)unwindToCredentialsList:(UIStoryboardSegue *)unwindSegue;
{
    [self refetchData];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.keychainItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.keychainItems[indexPath.row][(__bridge id)kSecAttrServer];
    cell.detailTextLabel.text = self.keychainItems[indexPath.row][(__bridge id)kSecAttrAccount];
    return cell;
}

#pragma mark - Private

- (void)refetchData;
{
    self.keychainItems = @[];
    
    NSDictionary *query = @{ (__bridge id)kSecClass : (__bridge id)kSecClassInternetPassword,
                             (__bridge id)kSecReturnAttributes : (__bridge id)kCFBooleanTrue,
                             (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitAll };
    CFTypeRef result = NULL;
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    switch (status) {
        case errSecSuccess:
            break; // great!
            
        case errSecItemNotFound:
            return; // nothing to display
            
        default:
            NSLog(@"Error fetching keychain contents: %td", (NSInteger)status);
            return;
    }
    
    if ([(__bridge id)result isKindOfClass:[NSDictionary class]]) {
        self.keychainItems = @[ (__bridge NSDictionary *)result ];
    } else if ([(__bridge id)result isKindOfClass:[NSArray class]]) {
        self.keychainItems = (__bridge NSArray *)result;
    } else {
        NSLog(@"unexpected result class: %@", NSStringFromClass([(__bridge id)result class]));
    }
}

@end
