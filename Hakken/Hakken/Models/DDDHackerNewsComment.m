//
//  DDDHackerNewsComment.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/20/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDHackerNewsComment.h"

@implementation DDDHackerNewsComment
+ (NSString *)primaryKey
{
    return @"id";
}

// Ugh pretty stupid that realm actually needs this, what if this doesn't come back in services?
+ (NSDictionary *)defaultPropertyValues
{
    return @{
             @"kids" : @[],
             @"parent"  : @(0),
             @"text"    : @"",
             @"deleted" : @(NO),
             @"by"      : @""
             };
}

+ (NSArray *)ignoredProperties
{
    return @[@"dateCreated", @"itemType"];
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
