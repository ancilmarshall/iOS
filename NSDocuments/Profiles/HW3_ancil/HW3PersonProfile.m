//
//  HW3PersonProfile.m
//  HW3_ancil
//
//  Created by Ancil on 7/26/14.
//  Copyright (c) 2014 Ancil Marshall. All rights reserved.
//

#import "HW3PersonProfile.h"

@implementation HW3PersonProfile

//constants associated with the nscoding functions
static NSString* nameKey = @"NAME_KEY";
static NSString* addressKey = @"ADDRESS_KEY";
static NSString* notesKey = @"NOTES_KEY";
static NSString* imageKey = @"IMAGE_KEY";

-(instancetype)init
{
    self = [super init];
    if (self){
        _name = @"";
        _address = @"";
        _notes = @"";
        _image = [NSImage imageNamed:@"eiffel.JPG"]; 
    }
    return self;
}

#pragma mark - Required NSCoding delegate methods
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:nameKey];
    [aCoder encodeObject:self.address forKey:addressKey];
    [aCoder encodeObject:self.notes forKey:notesKey];
    [aCoder encodeObject:self.image forKey:imageKey];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:nameKey];
        _address = [aDecoder decodeObjectForKey:addressKey];
        _notes = [aDecoder decodeObjectForKey:notesKey];
        _image = [aDecoder decodeObjectForKey:imageKey];
    }
    return self;
}

@end
