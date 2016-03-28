//
//  RWTViewModelServices.h
//  RWTFlickrSearch
//
//  Created by Ancil on 12/21/15.
//  Copyright © 2015 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTFlickrSearch.h"

// this protocoal allows the viewModel to obtain an object that satisifies the RWTFlickrSearch protocol
// and it is the hook into the Model layer. A protocol allows hiding of the objects in the Model

@protocol RWTViewModelServices <NSObject>

//almost like a factory, meaning it provides different services. Each object returned must conform to a type of service
//I can envision adding other services, with different types of services (and protocols)

// notice that the viewModel does not need to know who implements the RWTFlickrSearch protocol... just needs
// any object that implements it... it stores a property of an object that references the object.
- (id<RWTFlickrSearch>) getFlickrSearchService;

- (void)pushViewModel:(id)viewModel;

@end
