//
//  RWTFlickrSearchViewModel.m
//  RWTFlickrSearch
//
//  Created by Ancil on 12/20/15.
//  Copyright © 2015 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchViewModel.h"
#import "RWTSearchResultsViewModel.h"

@implementation RWTFlickrSearchViewModel

-(instancetype) initWithServices:(id<RWTViewModelServices>)services;
{
    self = [super init];
    if (self){
        _services = services;
        [self initialize];
    }
    return self;
}

- (void)initialize;
{
    self.title = @"Flickr Search";
    
    //observe and react to changes in self.searchText
    RACSignal* validSearchSignal =
      [[RACObserve(self, searchText)
        map:^id(NSString* text) {
            return @(text.length > 3);
        }]
        distinctUntilChanged];
    
    [validSearchSignal subscribeNext:^(id x) {
        NSLog(@"search text is valid %@",x);
    }];
    
    
    self.executeSearch =
    [[RACCommand alloc] initWithEnabled:validSearchSignal
        signalBlock:^RACSignal *(id input) {
         return [self executeSearchSignal];
    }];
}


- (RACSignal*) executeSearchSignal {
    return [[[self.services getFlickrSearchService]
             flickrSearchSignal:self.searchText]
             doNext:^(id results) {
                RWTSearchResultsViewModel *resultsViewModel =
                [[RWTSearchResultsViewModel alloc] initWithSearchResults:results services:self.services];
                [self.services pushViewModel:resultsViewModel];
            }];
}

@end



































