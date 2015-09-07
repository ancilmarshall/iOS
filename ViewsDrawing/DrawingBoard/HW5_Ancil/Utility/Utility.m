//
//  Utility.m


#import "Utility.h"

@implementation Utility

+(NSMutableArray*)randomizeArray:(NSArray*)inputArray ForSize:(NSUInteger)outputsize
{
    
    //first calculate an array of indices for the entire input array
    NSMutableArray* indexArray = [[NSMutableArray alloc] init];
    for (int ii=0; ii < [inputArray count]; ii++) {
        [indexArray addObject:@(ii)];
    }
    
    NSMutableArray* outputArray = [[NSMutableArray alloc] init];
    NSUInteger numberElementsToAdd = outputsize;
    
    //validate numberElementsToAdd, limiting size to the input array's size
    if ( numberElementsToAdd > [inputArray count] )
    {
        numberElementsToAdd = [inputArray count];
    }
    
    while ( numberElementsToAdd > 0)
    {
        NSUInteger randomNumber = arc4random_uniform((unsigned int)[indexArray count]);
        NSInteger nextIndex = [ indexArray[randomNumber] integerValue];
        [outputArray addObject:inputArray[nextIndex]];
        [indexArray removeObjectAtIndex:randomNumber];
        numberElementsToAdd--;
    }
    
    return outputArray;
}



@end
