//
//  EditorViewController.m
//  CoreDataConcurrencyDemo
//
//  Created by Tim Ekl on 2015.01.18.
//  Copyright (c) 2015 Tim Ekl. All rights reserved.
//

#import "EditorViewController.h"

#import <CoreData/CoreData.h>

@interface EditorViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSManagedObject *editingObject;

@property (weak, nonatomic) IBOutlet UITextField *stringField;

@end

@implementation EditorViewController

- (void)setContext:(NSManagedObjectContext *)context;
{
    _context = context;
    
    //add a new object to this context
    self.editingObject = [NSEntityDescription insertNewObjectForEntityForName:@"StringEntity" inManagedObjectContext:context];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSParameterAssert(textField == self.stringField);
    
    NSString *newStringValue = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    
    //make changes to the object in the context
    [self.editingObject setValue:newStringValue forKey:@"string"];
    
    return YES;
}

@end
