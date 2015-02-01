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
    DDDHackerNewsItem *itemInRealm = [DDDHackerNewsItem objectForPrimaryKey:@(item.id)];
    DDDHakkenReadLaterInformation *info = itemInRealm.readLaterInformation;
    
    if (info.userWantsToReadLater)
    {
        safe_block(error)([NSError errorWithDomain:[NSString stringWithFormat:@"Item with id: %li already has been saved to be read later", (long)item.id] code:-1 userInfo:nil]);
    }
    else
    {
        [[RLMRealm defaultRealm] beginWriteTransaction];
        info.userWantsToReadLater = YES;
        info.dateUserSavedToReadLater = [NSDate date];
        info.dateUserInitiallySavedToReadLater = [info.dateUserSavedToReadLater copy];
        itemInRealm.readLaterInformation = info;
        [DDDHackerNewsItem createOrUpdateInDefaultRealmWithObject:itemInRealm];
        [[RLMRealm defaultRealm] commitWriteTransaction];
        safe_block(completion)(itemInRealm);
    }
}

+ (void)removeItemFromReadLater:(DDDHackerNewsItem *)item withCompletion:(DDDHackerNewsItemBlock)completion withError:(ErrorBlock)error
{
    DDDHackerNewsItem *itemInRealm = [DDDHackerNewsItem objectForPrimaryKey:@(item.id)];
    DDDHakkenReadLaterInformation *info = itemInRealm.readLaterInformation;
    if (!info.userWantsToReadLater)
    {
        safe_block(error)([NSError errorWithDomain:[NSString stringWithFormat:@"Item with id: %li has not been saved to be read later", (long)item.id] code:-1 userInfo:nil]);
    }
    else
    {
        [[RLMRealm defaultRealm] beginWriteTransaction];
        info.userWantsToReadLater = NO;
        info.dateUserSavedToReadLater = [NSDate distantPast];
        itemInRealm.readLaterInformation = info;
        [DDDHackerNewsItem createOrUpdateInDefaultRealmWithObject:itemInRealm];
        [[RLMRealm defaultRealm] commitWriteTransaction];
        safe_block(completion)(itemInRealm);
    }
}

+ (void)fetchAllItemsToReadLaterWithCompletion:(DDDHackerNewsItemArrayBlock)completion withError:(NSError *)error
{
    NSPredicate *readLaterPredicate = [NSPredicate predicateWithBlock:^BOOL(DDDHackerNewsItem *evaluatedObject, NSDictionary *bindings) {
        return (evaluatedObject.readLaterInformation.userWantsToReadLater);
    }];
    
    RLMResults *results = [DDDHackerNewsItem objectsInRealm:[RLMRealm defaultRealm] withPredicate:readLaterPredicate];
    safe_block(completion)([results arrayFromResults]);
}

+ (void)fetchReadReadLaterItemsWithCompletion:(DDDHackerNewsItemArrayBlock)completion withError:(NSError *)error
{
    NSPredicate *readLaterPredicate = [NSPredicate predicateWithBlock:^BOOL(DDDHackerNewsItem *evaluatedObject, NSDictionary *bindings) {
        return (evaluatedObject.readLaterInformation.hasUserReadItem);
    }];
    
    RLMResults *results = [DDDHackerNewsItem objectsInRealm:[RLMRealm defaultRealm] withPredicate:readLaterPredicate];
    safe_block(completion)([results arrayFromResults]);
}

+ (void)fetchUnreadReadLaterItemsWithCompletion:(DDDHackerNewsItemArrayBlock)completion withError:(NSError *)error
{
    NSPredicate *readLaterPredicate = [NSPredicate predicateWithBlock:^BOOL(DDDHackerNewsItem *evaluatedObject, NSDictionary *bindings) {
        return ((!evaluatedObject.readLaterInformation.hasUserReadItem) && (evaluatedObject.readLaterInformation.userWantsToReadLater));
    }];
    
    RLMResults *results = [DDDHackerNewsItem objectsInRealm:[RLMRealm defaultRealm] withPredicate:readLaterPredicate];
    safe_block(completion)([results arrayFromResults]);
}

+ (void)removeAllItemsFromReadLaterWithCompletion:(DDDHackerNewsItemArrayBlock)completion withError:(NSError *)error
{
    NSPredicate *readLaterPredicate = [NSPredicate predicateWithBlock:^BOOL(DDDHackerNewsItem *evaluatedObject, NSDictionary *bindings) {
        return (evaluatedObject.readLaterInformation.hasUserReadItem);
    }];
    
    RLMResults *results = [DDDHackerNewsItem objectsInRealm:[RLMRealm defaultRealm] withPredicate:readLaterPredicate];
    NSArray *arrayResults = [results arrayFromResults];
    [arrayResults enumerateObjectsUsingBlock:^(DDDHackerNewsItem *item, NSUInteger idx, BOOL *stop) {
        [self removeItemFromReadLater:item withCompletion:nil withError:nil];
    }];
    safe_block(completion)(arrayResults);
}
@end
