//
//  HW3PersonProfile.h
//  HW3_ancil
//
//  Created by Ancil on 7/26/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import <Foundation/Foundation.h>

// Implement the NSCoding protocol to encode and decode this object
@interface HW3PersonProfile : NSObject <NSCoding>

@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* address;
@property (nonatomic,strong) NSImage* image;
@property (nonatomic,strong) NSString* notes;

@end
