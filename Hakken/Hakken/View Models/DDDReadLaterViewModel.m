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
#import "DDDHackerNewsItem.h"

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
        weakSelf.viewModelError = error;
    }];
}

- (void)removeStoryFromReadLater:(DDDHackerNewsItem *)story completion:(DDDHackerNewsItemBlock)completion error:(ErrorBlock)error
{
    [super removeStoryFromReadLater:story completion:^(DDDHackerNewsItem *item){
        __weak typeof(self) weakSelf = self;
        [DDDHakkenReadLaterManager fetchAllItemsToReadLaterWithCompletion:^(NSArray *items) {
            DDDArrayInsertionDeletion *arrayInsertionDeletion = [DDDArrayInsertionDeletion new];
            NSIndexPath *idxPathForStory = [self indexPathOfItem:story inArrayInsertionDeletion:self.latestStoriesUpdate];
            NSIndexSet *idxPathsRemoved = [self indexSetFromIndexPaths:@[idxPathForStory]];
            arrayInsertionDeletion.array = items;
            arrayInsertionDeletion.indexesDeleted = idxPathsRemoved;
            arrayInsertionDeletion.indexesInserted = nil;
            weakSelf.latestStoriesUpdate = arrayInsertionDeletion;
        } withError:error];;
    } error:error];
}

- (void)saveStoryToReadLater:(DDDHackerNewsItem *)story completion:(DDDHackerNewsItemBlock)completion error:(ErrorBlock)error
{
    [super saveStoryToReadLater:story completion:^(DDDHackerNewsItem *item){
        __weak typeof(self) weakSelf = self;
        [DDDHakkenReadLaterManager fetchAllItemsToReadLaterWithCompletion:^(NSArray *items) {
            DDDArrayInsertionDeletion *arrayInsertionDeletion = [DDDArrayInsertionDeletion new];
            NSIndexPath *idxPathForStory = [self indexPathOfItem:story inArrayInsertionDeletion:self.latestStoriesUpdate];
            NSIndexSet *idxPathsAdded = [self indexSetFromIndexPaths:@[idxPathForStory]];
            arrayInsertionDeletion.array = items;
            arrayInsertionDeletion.indexesDeleted = nil;
            arrayInsertionDeletion.indexesInserted = idxPathsAdded;
            weakSelf.latestStoriesUpdate = arrayInsertionDeletion;
        } withError:error];;
    } error:error];
}

- (NSIndexPath *)indexPathOfItem:(DDDHackerNewsItem *)item inArrayInsertionDeletion:(DDDArrayInsertionDeletion *)arrayInsertionDeletion
{
    __block NSInteger itemIdx = NSNotFound;
    [self.latestStoriesUpdate.array enumerateObjectsUsingBlock:^(DDDHackerNewsItem *obj, NSUInteger idx, BOOL *stop) {
        if (item.id  == obj.id)
            itemIdx = idx;
    }];
    return [NSIndexPath indexPathForRow:itemIdx inSection:0];
}

- (NSIndexSet *)indexSetFromIndexPaths:(NSArray *)indexPaths
{
    NSMutableIndexSet *idxSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *idxPath in indexPaths)
        [idxSet addIndex:idxPath.row];
    return idxSet;
}

- (DDDArrayInsertionDeletion *)arrayInsertionDeletionFromInsertedIndexPaths:(NSArray *)insertedIndexpaths
                                                      withDeletedIndexPaths:(NSArray *)deletedIndexpaths
                                                                  withArray:(NSArray *)array
{
    DDDArrayInsertionDeletion *insertionDeletion = [DDDArrayInsertionDeletion new];
    insertionDeletion.indexesDeleted = [self indexSetFromIndexPaths:deletedIndexpaths];
    insertionDeletion.indexesInserted = [self indexSetFromIndexPaths:insertedIndexpaths];
    insertionDeletion.array = array;
    return insertionDeletion;
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
