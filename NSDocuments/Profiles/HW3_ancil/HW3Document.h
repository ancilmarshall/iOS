//
//  HW3Document.h
//  HW3_ancil
//
//  Created by Ancil on 7/26/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class HW3PersonProfile;

@interface HW3Document : NSDocument <NSTextFieldDelegate, NSWindowDelegate>
@property (nonatomic, strong) HW3PersonProfile* personProfile;
@end
