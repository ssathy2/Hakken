//
//  DDDResponseSerializer.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/22/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDHackernewsItemResponseSerializer.h"
#import "DDDHackerNewsComment.h"

@implementation DDDHackernewsItemResponseSerializer

+ (NSArray *)arrayOfCommentsFromJSON:(NSDictionary *)json
{
    NSMutableArray *serializedItems = [NSMutableArray array];
    for (NSDictionary *rawItem in [json valueForKey:@"items"])
        [serializedItems addObject:[[DDDHackerNewsComment alloc] initWithDictionary:rawItem]];
    return serializedItems;
}

+ (NSArray *)arrayOfItemsFromJSONArray:(NSArray *)jsonArray
{
    NSMutableArray *serializedItems = [NSMutableArray array];
    for (NSDictionary *rawItem in jsonArray)
        [serializedItems addObject:[[DDDHackernewsItem alloc] initWithDictionary:rawItem]];
    return serializedItems;
}
@end
