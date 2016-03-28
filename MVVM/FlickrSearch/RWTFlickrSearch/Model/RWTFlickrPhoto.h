//
//  RWTFlickrPhoto.h
//  RWTFlickrSearch
//
//  Created by Ancil on 12/26/15.
//  Copyright © 2015 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWTFlickrPhoto : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSString *identifier;
@end
