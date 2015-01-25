//
//  DDDHackerNewsItem.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/26/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDHackerNewsItem.h"

@implementation RLMNumberObject
@end

@implementation DDDHackerNewsItem
+ (NSString *)primaryKey
{
    return @"id";
}

// Ugh pretty stupid that realm actually needs this, what if this doesn't come back in services?
+ (NSDictionary *)defaultPropertyValues
{
    return @{
             @"deleted" : @(NO),
             @"dead"    : @(NO),
             @"parent"  : @(0),
             @"text"    : @"",
             @"userWantsToReadLater" : @(NO),
             @"dateUserSavedToReadLater" : [NSDate distantPast],
             @"dateUserLastAccessed" : [NSDate distantPast]
             };
}

+ (NSArray *)ignoredProperties
{
    return @[@"dateCreated", @"itemType", @"itemURL"];
}

- (NSURL *)itemURL
{
    return [NSURL URLWithString:self.url];
}

- (NSDate *)dateCreated
{
    return [NSDate dateWithTimeIntervalSince1970:self.time];
}

- (DDDHackerNewsItemType)itemType
{
    if (_itemType != DDDHackerNewsItemTypeUndetermined)
    {
        NSNumber *rawEnumValue = [[self itemTypeMapping] valueForKey:self.type];
        _itemType = (DDDHackerNewsItemType)rawEnumValue.integerValue;
    }
    return _itemType;
}

- (NSDictionary *)itemTypeMapping
{
    return @{
        @"story"      : @(DDDHackerNewsItemTypeStory),
        @"comment"    : @(DDDHackerNewsItemTypeComment),
        @"poll"       : @(DDDHackerNewsItemTypePoll),
        @"pollopt"    : @(DDDHackerNewsItemTypePollOption),
        @"job"        : @(DDDHackerNewsItemTypeJob)
    };
};
@end