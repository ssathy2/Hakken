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
+ (NSArray *)arrayOfItemsFromJSONArray:(NSArray *)jsonArray
{
    NSMutableArray *serializedItems = [NSMutableArray array];
    for (NSDictionary *rawItem in jsonArray)
        [serializedItems addObject:[self itemFromJSON:rawItem]];
    return serializedItems;
}

+ (NSArray *)arrayOfItemsFromJSON:(NSDictionary *)json
{
    // TODO: replace back with items
    NSArray *rawItems = [json valueForKey:@"items"];
    return [self arrayOfItemsFromJSONArray:rawItems];
}

+ (DDDHackerNewsItem *)itemFromJSON:(NSDictionary *)json
{
    return [[DDDHackerNewsItem alloc] initWithDictionary:json];
}
@end
