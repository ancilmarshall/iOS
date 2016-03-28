//
//  RWTViewModelServicesImpl.m
//  RWTFlickrSearch
//
//  Created by Ancil on 12/22/15.
//  Copyright © 2015 Colin Eberhardt. All rights reserved.
//

// This class is part of the Model layer, and it's function is to provide the ViewModel
// with its needed model services. It does this by conforming to the protocol specified
// by the ViewModel. If this protocol updates, then this class is the only place that needs
// to be updated to provide the hooks between the Model layer and the ViewModel layer.
// OK to have strong properties to needed services and instantiate them as instance variables
// within this class.


#import "RWTViewModelServicesImpl.h"
#import "RWTFlickrSearchImpl.h"
#import "RWTSearchResultsViewController.h"

@interface RWTViewModelServicesImpl()
@property (strong, nonatomic) RWTFlickrSearchImpl *searchService;
@property (weak, nonatomic) UINavigationController* navigationController;
@end

@implementation RWTViewModelServicesImpl


- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;
{
    if (self = [super init]) {
        _searchService = [RWTFlickrSearchImpl new];
        _navigationController = navigationController;
    }
    return self;
}

- (id<RWTFlickrSearch>) getFlickrSearchService;
{
    return self.searchService;
}

- (void)pushViewModel:(id)viewModel {
    id viewController;
    
    if ([viewModel isKindOfClass:RWTSearchResultsViewModel.class]) {
        viewController = [[RWTSearchResultsViewController alloc] initWithViewModel:viewModel];
    } else {
        NSLog(@"an unknown ViewModel was pushed!");
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
