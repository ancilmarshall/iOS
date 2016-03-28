//
//  RWTViewModelServicesImpl.h
//  RWTFlickrSearch
//
//  Created by Ancil on 12/22/15.
//  Copyright © 2015 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTViewModelServices.h"

@interface RWTViewModelServicesImpl : NSObject <RWTViewModelServices>
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;
@end
