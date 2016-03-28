//
//  RWTSearchResultsViewModel.h
//  RWTFlickrSearch
//
//  Created by Ancil on 12/26/15.
//  Copyright © 2015 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTFlickrSearchResults.h"
#import "RWTViewModelServices.h"

@interface RWTSearchResultsViewModel : NSObject



//Note, can init with the RWTFlickrSearchResults since this is part of the Model layer ande the viewModel
// is allowed to have a reference to the Model
- (instancetype)initWithSearchResults:(RWTFlickrSearchResults *)results services:(id<RWTViewModelServices>)services;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *searchResults;

@end
