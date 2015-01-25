//
//  DDDReadLaterHelper.m
//  Hakken
//
//  Created by Sidd Sathyam on 1/11/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "DDDReadLaterHelper.h"

@implementation DDDReadLaterHelper
+ (instancetype) sharedInstance
{
    static DDDReadLaterHelper* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DDDReadLaterHelper alloc] init];
        // do any init for the shared instance here
    });
    return sharedInstance;
}
@end
