//
//  RWTSearchResultsViewModel.m
//  RWTFlickrSearch
//
//  Created by Ancil on 12/26/15.
//  Copyright © 2015 Colin Eberhardt. All rights reserved.
//

#import "RWTSearchResultsViewModel.h"

@implementation RWTSearchResultsViewModel


- (instancetype)initWithSearchResults:(RWTFlickrSearchResults *)results services:(id<RWTViewModelServices>)services {
    if (self = [super init]) {
        _title = results.searchString;
        _searchResults = results.photos;
    }
    return self;
}


@end
