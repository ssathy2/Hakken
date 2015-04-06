//
//  DDDHakkenReadLaterInformation.m
//  Hakken
//
//  Created by Sidd Sathyam on 1/31/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "DDDHakkenReadLaterInformation.h"
@implementation DDDHakkenReadLaterInformation
+ (NSDictionary *)defaultPropertyValues
{
    return @{
             @"userWantsToReadLater" : @(NO),
             @"dateUserInitiallySavedToReadLater" : [NSDate distantPast],
             @"dateUserSavedToReadLater" : [NSDate distantPast],
             @"dateUserLastRead"     : [NSDate distantPast]
             };
}

+ (NSArray *)ignoredProperties
{
    return @[@"hasUserReadItem"];
}

+ (instancetype)defaultObject
{
    DDDHakkenReadLaterInformation *readLaterInformation = [DDDHakkenReadLaterInformation new];
    readLaterInformation.userWantsToReadLater           = NO;
    readLaterInformation.dateUserInitiallySavedToReadLater = readLaterInformation.dateUserLastRead = readLaterInformation.dateUserSavedToReadLater = [NSDate distantPast];
    return readLaterInformation;
}

- (BOOL)hasUserReadItem
{
    return ([self.dateUserLastRead timeIntervalSinceDate:[NSDate distantPast]] != 0);
}

@end
