//
//  DDDReadLaterViewModel.m
//  Hakken
//
//  Created by Sidd Sathyam on 2/1/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "DDDReadLaterViewModel.h"
#import "DDDArrayInsertionDeletion.h"
#import "DDDHakkenReadLaterManager.h"
#import "DDDHakkenReadLater.h"

typedef void(^ArrayBlock)(NSArray *array);
typedef void(^ArrayInsertionDeletionBlock)(DDDArrayInsertionDeletion *arrayInsertionDeletion);

@implementation DDDReadLaterViewModel
- (void)viewModelDidLoad
{
    [super viewModelDidLoad];
    __weak typeof(self) weakSelf = self;
    [self generateArrayInsertionDeletionFromUnreadItems:^(DDDArrayInsertionDeletion *arrayInsertionDeletion) {
        weakSelf.latestStoriesUpdate = arrayInsertionDeletion;
    } withError:^(NSError *error) {
        
    }];
}

- (void)removeStoryFromReadLater:(DDDHackerNewsItem *)story completion:(DDDHackerNewsItemBlock)completion error:(ErrorBlock)error
{
    [super removeStoryFromReadLater:story completion:completion error:error];
    __weak typeof(self) weakSelf = self;
    [self generateArrayInsertionDeletionFromUnreadItems:^(DDDArrayInsertionDeletion *arrayInsertionDeletion) {
        weakSelf.latestStoriesUpdate = arrayInsertionDeletion;
    } withError:^(NSError *error) {
        // handle this
    }];
}

- (void)saveStoryToReadLater:(DDDHackerNewsItem *)story completion:(DDDHackerNewsItemBlock)completion error:(ErrorBlock)error
{
    [super saveStoryToReadLater:story completion:completion error:error];
    __weak typeof(self) weakSelf = self;
    [self generateArrayInsertionDeletionFromUnreadItems:^(DDDArrayInsertionDeletion *arrayInsertionDeletion) {
        weakSelf.latestStoriesUpdate = arrayInsertionDeletion;
    } withError:^(NSError *error) {
        // handle this
    }];
}

- (void)generateArrayInsertionDeletionFromUnreadItems:(ArrayInsertionDeletionBlock)completion withError:(ErrorBlock)error
{
    [DDDHakkenReadLaterManager fetchAllItemsToReadLaterWithCompletion:^(NSArray *items) {
        DDDArrayInsertionDeletion *insertionDeletion    = [DDDArrayInsertionDeletion new];
        insertionDeletion.array                         = items;
        insertionDeletion.indexesDeleted                = nil;
        insertionDeletion.indexesInserted               = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, items.count)];
        completion(insertionDeletion);
    } withError:error];
}
@end
