//
//  Item.h
//
#import <Foundation/Foundation.h>

@interface Item : NSObject


@property (nonatomic,strong) NSString* question;
@property (nonatomic,strong) NSString* answer;

//initializer
-(instancetype)initWithQuestion:(NSString*)question
                         Answer:(NSString*)answer;


@end
