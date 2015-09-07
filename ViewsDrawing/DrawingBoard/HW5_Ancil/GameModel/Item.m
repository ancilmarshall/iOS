//
//  Item.m
//

#import "Item.h"

@implementation Item

/*
 * Initializer method that takes three parameters
 */
-(instancetype)initWithQuestion:(NSString*)question
                         Answer:(NSString*)answer
{
    self = [super init];
    
    if (self) {
        _question = question;
        _answer = answer;
    }
    
    return self;
}

-(BOOL) isEqual:(Item*)item
{
    if ( self.question == item.question &&
         self.answer == item.answer )
        return YES;
    else
        return NO;
}


@end
