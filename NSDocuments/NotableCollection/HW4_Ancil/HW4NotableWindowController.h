//
//  HW4NotableWindowController.h
//  HW4_Ancil
//
//  Created by Ancil on 8/7/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HW2TodoList.h"

@interface HW4NotableWindowController : NSWindowController <NSTableViewDataSource,
    NSTableViewDelegate, NSTextFieldDelegate, HW2TodoListDelegate>
@property (strong,nonatomic) HW2TodoList* list;

@end
