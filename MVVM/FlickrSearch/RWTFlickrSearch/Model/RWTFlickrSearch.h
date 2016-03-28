//
//  RWTFlickrSearch.h
//  RWTFlickrSearch
//
//  Created by Ancil on 12/21/15.
//  Copyright © 2015 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol RWTFlickrSearch <NSObject>

- (RACSignal*) flickrSearchSignal:(NSString*)searchText;

@end
