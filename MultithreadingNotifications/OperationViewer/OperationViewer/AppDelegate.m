//
//  AppDelegate.m
//  OperationViewer
//
//  Created by Tim Ekl on 1/25/14.
//  Copyright (c) 2014 Tim Ekl. All rights reserved.
//

#import "AppDelegate.h"

#import "Operation.h"
#import "OperationViewController.h"
#import "OperationViewControllerDelegate.h"

@interface AppDelegate () <OperationViewControllerDelegate, NSStackViewDelegate>

@property (nonatomic, weak) IBOutlet NSStackView *stackView;

@property (nonatomic, strong) NSMutableArray *operationQueueControllers;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.operationQueueControllers = [NSMutableArray array];
    
    [self addOperationQueueController:nil];
}

#pragma mark - Actions

- (IBAction)addOperationQueueController:(id)sender;
{
    OperationViewController *controller = [[OperationViewController alloc] init];
    controller.delegate = self;
    [self.operationQueueControllers addObject:controller];
    
    NSView *view = [controller view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.stackView addView:view inGravity:NSStackViewGravityCenter];
    
    if ([self.stackView.views count] > 1) {
        [self.stackView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.stackView.views[0]
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1.0f
                                                                    constant:0.0f]];
    }
}

#pragma mark - OperationViewControllerDelegate

- (NSString *)nameForNewOperationQueue:(OperationViewController *)controller;
{
    static NSArray *names = nil;
    static NSUInteger index = 0;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        names = @[ @"Alpha", @"Beta", @"Gamma", @"Delta", @"Epsilon", @"Zeta", @"Eta", @"Theta", @"Iota", @"Kappa", @"Lambda", @"Mu", @"Nu", @"Xi", @"Omicron", @"Pi", @"Rho", @"Sigma", @"Tau", @"Upsilon", @"Phi", @"Chi", @"Psi", @"Omega" ];
    });
    
    NSString *name = names[index];
    index = (index + 1) % [names count];
    return name;
}

- (Operation *)operationController:(OperationViewController *)controller operationNamed:(NSString *)operationName inQueueNamed:(NSString *)queueName;
{
    for (OperationViewController *knownController in self.operationQueueControllers) {
        if (![knownController.operationQueueName isEqualToString:queueName])
            continue;
        
        for (NSOperation *operation in knownController.operations) {
            if ([operation isKindOfClass:[Operation class]] && [[(Operation *)operation name] isEqualToString:operationName])
                return (Operation *)operation;
        }
    }
    
    return nil;
}

@end
