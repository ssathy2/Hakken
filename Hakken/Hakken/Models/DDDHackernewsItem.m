//
//  DDDHackernewsItem.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/26/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDHackernewsItem.h"

@implementation DDDHackernewsItem
- (void)setupPropertyMappingsWithDictionary:(NSDictionary *)dictionary
{
    [super setupPropertyMappingsWithDictionary:dictionary];

    [self setEnumerationMapping:@{
                                  @"job"     : @(DDDHackerNewsItemTypeJob),
                                  @"story"   : @(DDDHackerNewsItemTypeStory),
                                  @"comment" : @(DDDHackerNewsItemTypeComment),
                                  @"poll"    : @(DDDHackerNewsItemTypePoll),
                                  @"pollopt" : @(DDDHackerNewsItemTypePollOption)
                                  }
                         forKey: @"type"];
    [self setArrayOfModelsWithClass:[DDDHackernewsItem class] forKey:@"parts"];
}
@end
