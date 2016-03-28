//
//  RWTFlickrSearchResults.m
//  RWTFlickrSearch
//
//  Created by Ancil on 12/26/15.
//  Copyright © 2015 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchResults.h"

@implementation RWTFlickrSearchResults

- (NSString *)description {
    return [NSString stringWithFormat:@"searchString=%@, totalresults=%lU, photos=%@",
            self.searchString, self.totalResults, self.photos];
}

@end
