//
//  DetailsViewController.m
//  UWHWKeychain
//
//  Created by Tim Ekl on 11/11/14.
//  Copyright (c) 2014 Tim Ekl. All rights reserved.
//

#import "DetailsViewController.h"

static NSInteger DetailsViewControllerSaveButtonTag = 1001;

@interface DetailsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *hostnameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (nonatomic, copy) NSDictionary *originalAttributes;

@end

@implementation DetailsViewController

#pragma mark - API

- (void)showDetailsForItemAttributes:(NSDictionary *)itemAttributes;
{
    self.originalAttributes = itemAttributes;
    if (itemAttributes == nil) {
        return;
    }
    
    if ([self isViewLoaded]) {
        [self configureView];
    }
}

#pragma mark - UIViewController subclass

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    if (self.originalAttributes != nil) {
        [self configureView];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender;
{
    if ([sender isKindOfClass:[UIBarButtonItem class]] && [sender tag] == DetailsViewControllerSaveButtonTag) {
        // Make sure we have text
        if ([self.hostnameField.text length] == 0 || [self.usernameField.text length] == 0 || [self.passwordField.text length] == 0) {
            return NO;
        }
        
        // Make sure the hostname is legal
        NSDictionary *query = @{ (__bridge id)kSecClass : (__bridge id)kSecClassInternetPassword,
                                 (__bridge id)kSecAttrServer : self.hostnameField.text,
                                 (__bridge id)kSecReturnAttributes : (__bridge id)kCFBooleanTrue };
        if (SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL) == errSecSuccess) {
            if (![self.originalAttributes[(__bridge id)kSecAttrServer] isEqualToString:self.hostnameField.text]) {
                NSString *message = [NSString stringWithFormat:NSLocalizedString(@"There is another entry for hostname %@. Change the hostname and try again.", nil), self.hostnameField.text];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
                                                                                         message:message
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
                return NO;
            }
        }
    }
    
    // Allow all other changes
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
{
    if ([sender isKindOfClass:[UIBarButtonItem class]] && [sender tag] == DetailsViewControllerSaveButtonTag) {
        NSAssert([self.hostnameField.text length] > 0, @"Need a hostname");
        NSAssert([self.usernameField.text length] > 0, @"Need a username");
        NSAssert([self.passwordField.text length] > 0, @"Need a password");
        
        if (self.originalAttributes != nil) {
            [self updateKeychainItem:sender];
        } else {
            [self createKeychainItem:sender];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (textField == self.hostnameField) {
        [self.usernameField becomeFirstResponder];
    } else if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    }
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    // First check if the other text fields are valid
    BOOL saveable = YES;
    for (UITextField *field in @[ self.hostnameField, self.usernameField, self.passwordField ]) {
        if (field != textField && [field.text length] == 0) {
            saveable = NO;
            break;
        }
    }
    
    // Then check if this field would be valid after the replacement
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    saveable = saveable && ([newString length] > 0);
    
    // Update the Save button
    self.saveButton.enabled = saveable;
    
    // Always allow the replacement, even if it would disable saving
    return YES;
}

#pragma mark - Private

- (void)configureView;
{
    NSDictionary *query = @{ (__bridge id)kSecClass : (__bridge id)kSecClassInternetPassword,
                             (__bridge id)kSecAttrServer : self.originalAttributes[(__bridge id)kSecAttrServer],
                             (__bridge id)kSecReturnData : (__bridge id)kCFBooleanTrue };
    CFTypeRef result = NULL;
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status == errSecSuccess) {
        self.hostnameField.text = self.originalAttributes[(__bridge id)kSecAttrServer];
        self.usernameField.text = self.originalAttributes[(__bridge id)kSecAttrAccount];
        self.passwordField.text = [[NSString alloc] initWithData:(__bridge NSData *)result encoding:NSUTF8StringEncoding];
        self.saveButton.enabled = YES;
    } else {
        NSLog(@"Couldn't fetch keychain item for editing: %td", (NSInteger)status);
    }
}

- (OSStatus)createKeychainItem:(id)sender;
{
    NSDictionary *attributes = @{ (__bridge id)kSecClass : (__bridge id)kSecClassInternetPassword,
                                  (__bridge id)kSecAttrServer : self.hostnameField.text,
                                  (__bridge id)kSecAttrAccount : self.usernameField.text,
                                  (__bridge id)kSecAttrCreationDate : [NSDate date],
                                  (__bridge id)kSecAttrModificationDate : [NSDate date],
                                  (__bridge id)kSecValueData : [self.passwordField.text dataUsingEncoding:NSUTF8StringEncoding] };
    
    return SecItemAdd((__bridge CFDictionaryRef)attributes, NULL);
}

- (OSStatus)updateKeychainItem:(id)sender;
{
    NSDictionary *query = @{ (__bridge id)kSecClass : (__bridge id)kSecClassInternetPassword,
                             (__bridge id)kSecAttrServer : self.originalAttributes[(__bridge id)kSecAttrServer] };
    NSDictionary *attributesToUpdate = @{ (__bridge id)kSecAttrServer : self.hostnameField.text,
                                          (__bridge id)kSecAttrAccount : self.usernameField.text,
                                          (__bridge id)kSecAttrModificationDate : [NSDate date],
                                          (__bridge id)kSecValueData : [self.passwordField.text dataUsingEncoding:NSUTF8StringEncoding] };
    
    return SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributesToUpdate);
}

@end
