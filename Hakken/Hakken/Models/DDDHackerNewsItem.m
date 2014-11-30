//
//  DDDHackerNewsItem.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/26/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDHackerNewsItem.h"

@implementation DDDHackerNewsItem
- (void)setupPropertyMappingsWithDictionary:(NSDictionary *)dictionary
{
    [super setupPropertyMappingsWithDictionary:dictionary];
    [self setEnumerationMapping:@{
                                  @"story"      : @(DDDHackerNewsItemTypeStory),
                                  @"comment"    : @(DDDHackerNewsItemTypeComment),
                                  @"poll"       : @(DDDHackerNewsItemTypePoll),
                                  @"pollopt"    : @(DDDHackerNewsItemTypePollOption),
                                  @"job"        : @(DDDHackerNewsItemTypeJob)
                                  }
                         forKey:@keypath(self.type)];
}

- (NSURL *)itemURL
{
    return [NSURL URLWithString:self.url];
}

@end