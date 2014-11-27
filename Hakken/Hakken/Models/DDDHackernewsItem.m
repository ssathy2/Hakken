//
//  DDDHackerNewsItem.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/20/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDHackerNewsItem.h"

@implementation DDDHackerNewsItem
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
    [self setArrayOfModelsWithClass:[DDDHackerNewsItem class] forKey:@"parts"];
    [self setArrayOfModelsWithClass:[DDDHackerNewsItem class] forKey:@"kids"];
}
@end
