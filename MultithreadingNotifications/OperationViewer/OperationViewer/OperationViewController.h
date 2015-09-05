//
//  OperationViewController.h
//  OperationViewer
//
//  Created by Tim Ekl on 1/25/14.
//  Copyright (c) 2014 Tim Ekl. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "OperationViewControllerDelegate.h"

@interface OperationViewController : NSViewController

@property (nonatomic, weak) id<OperationViewControllerDelegate> delegate;

@property (nonatomic, readonly) NSString *operationQueueName;
@property (nonatomic, readonly) NSArray *operations;

@end
