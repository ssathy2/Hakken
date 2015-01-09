//
//  DDDReactiveServices.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/22/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDDServices.h"

@interface DDDLiveDataServices : NSObject<DDDServices>
+ (instancetype)liveServicesWithBaseURL:(NSURL *)baseURL;
@end
