//
//  HW2AppDelegate.h
//  UW-iPhone120-HW2-AncilMarshall
//
//  Created by Ancil on 7/20/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HW2TodoList.h"

@interface HW2AppDelegate : NSObject <NSApplicationDelegate, HW2TodoListDelegate,
    NSWindowDelegate, NSTextFieldDelegate>

@property (assign) IBOutlet NSWindow *window;

@end
