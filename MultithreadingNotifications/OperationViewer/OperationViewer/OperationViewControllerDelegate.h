//
//  OperationViewControllerDelegate.h
//  OperationViewer
//
//  Created by Tim Ekl on 1/25/14.
//  Copyright (c) 2014 Tim Ekl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OperationViewController;
@class Operation;

@protocol OperationViewControllerDelegate <NSObject>

@required
- (NSString *)nameForNewOperationQueue:(OperationViewController *)controller;

@optional
/// Drag & drop support: find the Operation instance given a queue name and operation name (imported from the pasteboard)
- (Operation *)operationController:(OperationViewController *)controller operationNamed:(NSString *)operationName inQueueNamed:(NSString *)queueName;

@end
