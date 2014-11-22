//
//  DDDReactiveServices.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/22/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDReactiveServices.h"

@implementation DDDReactiveServices
+ (instancetype) sharedInstance
{
    static DDDReactiveServices* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DDDReactiveServices alloc] init];
        // do any init for the shared instance here
    });
    return sharedInstance;
}


@end
