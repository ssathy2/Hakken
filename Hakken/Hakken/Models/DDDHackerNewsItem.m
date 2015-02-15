//
//  DDDHackerNewsItem.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/26/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDHackerNewsItem.h"
#import "DDDHakkenReadLaterInformation.h"

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
             @"by"      : @"",
             @"url"     : @"",
             @"score"   : @(0),
             @"title"   : @"",
             @"readLaterInformation" : [DDDHakkenReadLaterInformation defaultObject]
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
    if (_itemType == DDDHackerNewsItemTypeUndetermined)
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

- (BOOL)isUserGenerated
{
    return self.url.length == 0;
}
@end