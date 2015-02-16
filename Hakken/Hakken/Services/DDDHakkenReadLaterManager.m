//
//  DDDHakkenReadLaterManager.m
//  Hakken
//
//  Created by Sidd Sathyam on 1/31/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "DDDHakkenReadLaterManager.h"
#import "DDDHackerNewsItem.h"
#import "DDDHakkenReadLaterInformation.h"

@implementation DDDHakkenReadLaterManager

#pragma mark - DDDHakkenReadLater
+ (void)addItemToReadLater:(DDDHackerNewsItem *)item withCompletion:(DDDHackerNewsItemBlock)completion withError:(ErrorBlock)error
{
    DDDHakkenReadLaterInformation *info = item.readLaterInformation;
    
    if (info.userWantsToReadLater)
    {
        safe_block(error)([NSError errorWithDomain:[NSString stringWithFormat:@"Item with id: %li already has been saved to be read later", (long)item.id] code:-1 userInfo:nil]);
    }
    else
    {
        [[RLMRealm defaultRealm] beginWriteTransaction];
        if (!info)
            info = [DDDHakkenReadLaterInformation new];
        info.userWantsToReadLater = YES;
        info.dateUserSavedToReadLater = [NSDate date];
        info.dateUserInitiallySavedToReadLater = [info.dateUserSavedToReadLater copy];
        item.readLaterInformation = info;
        [[RLMRealm defaultRealm] addOrUpdateObject:item];
        [[RLMRealm defaultRealm] commitWriteTransaction];
        safe_block(completion)(item);
    }
}

+ (void)removeItemFromReadLater:(DDDHackerNewsItem *)item withCompletion:(DDDHackerNewsItemBlock)completion withError:(ErrorBlock)error
{
    DDDHakkenReadLaterInformation *info = item.readLaterInformation;
    if (!info.userWantsToReadLater)
    {
        safe_block(error)([NSError errorWithDomain:[NSString stringWithFormat:@"Item with id: %li has not been saved to be read later", (long)item.id] code:-1 userInfo:nil]);
    }
    else
    {
        [[RLMRealm defaultRealm] beginWriteTransaction];
        if (!info)
            info = [DDDHakkenReadLaterInformation new];
        info.userWantsToReadLater = NO;
        info.dateUserSavedToReadLater = [NSDate distantPast];
        item.readLaterInformation = info;
        [[RLMRealm defaultRealm] addOrUpdateObject:item];
        [[RLMRealm defaultRealm] commitWriteTransaction];
        safe_block(completion)(item);
    }
}

+ (void)fetchAllItemsToReadLaterWithCompletion:(DDDHackerNewsItemArrayBlock)completion withError:(ErrorBlock)error
{
    NSPredicate *readLaterPredicate = [NSPredicate predicateWithFormat:@"readLaterInformation.userWantsToReadLater == YES"];
    
    RLMResults *results = [DDDHackerNewsItem objectsWithPredicate:readLaterPredicate];
    safe_block(completion)([results arrayFromResults]);
}

+ (void)fetchReadReadLaterItemsWithCompletion:(DDDHackerNewsItemArrayBlock)completion withError:(ErrorBlock)error
{
    NSPredicate *readLaterPredicate = [NSPredicate predicateWithFormat:@"readLaterInformation.hasUserReadItem == YES"];
    
    RLMResults *results = [DDDHackerNewsItem objectsWithPredicate:readLaterPredicate];
    safe_block(completion)([results arrayFromResults]);
}

+ (void)fetchUnreadReadLaterItemsWithCompletion:(DDDHackerNewsItemArrayBlock)completion withError:(ErrorBlock *)error
{
    NSPredicate *readLaterPredicate = [NSPredicate predicateWithFormat:@"readLaterInformation.userWantsToReadLater == YES AND readLaterInformation.hasUserReadItem == NO"];
    
    RLMResults *results = [DDDHackerNewsItem objectsWithPredicate:readLaterPredicate];
    safe_block(completion)([results arrayFromResults]);
}

+ (void)removeAllItemsFromReadLaterWithCompletion:(DDDHackerNewsItemArrayBlock)completion withError:(ErrorBlock)error
{
    [self fetchAllItemsToReadLaterWithCompletion:^(NSArray *items) {
        [items enumerateObjectsUsingBlock:^(DDDHackerNewsItem *item, NSUInteger idx, BOOL *stop) {
            [self removeItemFromReadLater:item withCompletion:nil withError:nil];
        }];
        safe_block(completion)(items);
    } withError:error];
    
}
@end
