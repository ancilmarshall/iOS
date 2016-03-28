//
//  RWTFlickrSearchResults.h
//  RWTFlickrSearch
//
//  Created by Ancil on 12/26/15.
//  Copyright © 2015 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWTFlickrSearchResults : NSObject
@property (strong, nonatomic) NSString *searchString;
@property (strong, nonatomic) NSArray *photos;
@property (nonatomic) NSUInteger totalResults;

@end
