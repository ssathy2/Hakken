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
+ (RACSignal *)addItemToReadLater:(DDDHackerNewsItem *)item
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        DDDHakkenReadLaterInformation *info = item.readLaterInformation;
        
        if (info.userWantsToReadLater)
            [subscriber sendError:[NSError errorWithDomain:[NSString stringWithFormat:@"Item with id: %li already has been saved to be read later", (long)item.id] code:-1 userInfo:nil]];
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
            [subscriber sendNext:item];
            [subscriber sendCompleted];
        }
        return nil;
    }];
}

+ (RACSignal *)markStoryAsRead:(DDDHackerNewsItem *)item
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[RLMRealm defaultRealm] beginWriteTransaction];
        DDDHakkenReadLaterInformation *info = item.readLaterInformation;
        info.dateUserLastRead = [NSDate date];
        item.readLaterInformation = info;
        [[RLMRealm defaultRealm] addOrUpdateObject:item];
        [[RLMRealm defaultRealm] commitWriteTransaction];
        [subscriber sendNext:item];
        [subscriber sendCompleted];
        return nil;
    }];
}

+ (RACSignal *)markStoryAsUnread:(DDDHackerNewsItem *)item
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[RLMRealm defaultRealm] beginWriteTransaction];
        DDDHakkenReadLaterInformation *info = item.readLaterInformation;
        info.dateUserLastRead = [NSDate distantPast];
        [[RLMRealm defaultRealm] addOrUpdateObject:item];
        [[RLMRealm defaultRealm] commitWriteTransaction];
        [subscriber sendNext:item];
        [subscriber sendCompleted];
        return nil;
    }];
}

+ (RACSignal *)removeItemFromReadLater:(DDDHackerNewsItem *)item
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        DDDHakkenReadLaterInformation *info = item.readLaterInformation;
        if (!info.userWantsToReadLater)
            [subscriber sendError:[NSError errorWithDomain:[NSString stringWithFormat:@"Item with id: %li has not been saved to be read later", (long)item.id] code:-1 userInfo:nil]];
        else
        {
            [[RLMRealm defaultRealm] beginWriteTransaction];
            info = [DDDHakkenReadLaterInformation new];
            info.userWantsToReadLater = NO;
            info.dateUserSavedToReadLater = [NSDate distantPast];
            info.dateUserLastRead = [NSDate distantPast];
            item.readLaterInformation = info;
            [[RLMRealm defaultRealm] addOrUpdateObject:item];
            [[RLMRealm defaultRealm] commitWriteTransaction];
            [subscriber sendNext:item];
            [subscriber sendCompleted];
        }
        return nil;
    }];
}

+ (RACSignal *)fetchAllItemsToReadLater
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSPredicate *readLaterPredicate = [NSPredicate predicateWithFormat:@"readLaterInformation.userWantsToReadLater == YES"];
        
        RLMResults *results = [DDDHackerNewsItem objectsWithPredicate:readLaterPredicate];
        [subscriber sendNext:[results arrayFromResults]];
        [subscriber sendCompleted];
        return nil;
    }];
}

+ (RACSignal *)fetchReadReadLaterItems
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
NSPredicate *readLaterPredicate = [NSPredicate predicateWithFormat:@"readLaterInformation.userWantsToReadLater == YES AND readLaterInformation.dateUserLastRead != %@", [NSDate distantPast]];
        
        RLMResults *results = [DDDHackerNewsItem objectsWithPredicate:readLaterPredicate];
        [subscriber sendNext:[results arrayFromResults]];
        [subscriber sendCompleted];
        return nil;
    }];
}

+ (RACSignal *)fetchUnreadReadLaterItems
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSPredicate *readLaterPredicate = [NSPredicate predicateWithFormat:@"readLaterInformation.userWantsToReadLater == YES AND readLaterInformation.dateUserLastRead == %@", [NSDate distantPast]];
        
        RLMResults *results = [DDDHackerNewsItem objectsWithPredicate:readLaterPredicate];
        [subscriber sendNext:[results arrayFromResults]];
        [subscriber sendCompleted];
        return nil;
    }];
}

+ (RACSignal *)removeAllItemsFromReadLater
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block NSArray *readItems;
        [[self fetchAllItemsToReadLater] subscribeNext:^(id x) {
            readItems = x;
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [readItems enumerateObjectsUsingBlock:^(DDDHackerNewsItem *item, NSUInteger idx, BOOL *stop) {
                [self removeItemFromReadLater:item];
            }];
            [subscriber sendNext:readItems];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}
@end
