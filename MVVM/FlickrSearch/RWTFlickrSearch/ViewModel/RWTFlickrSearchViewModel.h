//
//  RWTFlickrSearchViewModel.h
//  RWTFlickrSearch
//
//  Created by Ancil on 12/20/15.
//  Copyright © 2015 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RWTViewModelServices.h"

@interface RWTFlickrSearchViewModel : NSObject

//binding with the View based on UI input and actions
@property (strong, nonatomic) RACCommand* executeSearch;
@property (strong, nonatomic) NSString *searchText;

//View state provided by the ViewModel
@property (strong, nonatomic) NSString* title;

//reference to the Model
@property (weak, nonatomic) id<RWTViewModelServices> services;

//initializers needed
-(instancetype) initWithServices:(id<RWTViewModelServices>)services;

@end
