//
//  DDDResponseSerializer.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/22/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDHackernewsItemResponseSerializer.h"
#import "DDDHackerNewsItem.h"

@implementation DDDHackernewsItemResponseSerializer
+ (NSArray *)arrayOfItemsFromJSON:(NSDictionary *)json
{
    NSArray *rawItems               = [json valueForKey:@"items"];
    NSMutableArray *serializedItems = [NSMutableArray array];
    for (NSDictionary *rawItem in rawItems)
        [serializedItems addObject:[self itemFromJSON:rawItem]];
    return serializedItems;
}

+ (DDDHackerNewsItem *)itemFromJSON:(NSDictionary *)json
{
    return [[DDDHackerNewsItem alloc] initWithDictionary:json];
}
@end
