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
    
    __block NSArray *results;
    [[DDDHakkenReadLaterManager fetchAllItemsToReadLater] subscribeNext:^(id x) {
        results = x;
    } error:^(NSError *error) {
        weakSelf.viewModelError = error;
    } completed:^{
        [weakSelf.latestStoriesUpdate addAllItemsIntoArrayFromArray:results];
    }];
}

- (RACSignal *)removeStoryFromReadLater:(DDDHackerNewsItem *)story
{
    __weak typeof(self) weakSelf = self;
    return [[self removeStoryFromReadLater:story] then:^RACSignal *{
        __block NSArray *results;
        [[DDDHakkenReadLaterManager fetchAllItemsToReadLater] subscribeNext:^(id x) {
            results = x;
        } error:^(NSError *error) {
            weakSelf.viewModelError = error;
        } completed:^{
            NSIndexPath *idxPathForStory = [self indexPathOfItem:story inArrayInsertionDeletion:self.latestStoriesUpdate];
            NSIndexSet *idxPathsRemoved = [self indexSetFromIndexPaths:@[idxPathForStory]];
            [weakSelf.latestStoriesUpdate removeIndexesFromArray:idxPathsRemoved];
        }];
        return nil;
    }];
}

- (RACSignal *)saveStoryToReadLater:(DDDHackerNewsItem *)story
{
    __weak typeof(self) weakSelf = self;
    return [[self saveStoryToReadLater:story] then:^RACSignal *{
        __block NSArray *results;
        [[DDDHakkenReadLaterManager fetchAllItemsToReadLater] subscribeNext:^(id x) {
            results = x;
        } error:^(NSError *error) {
            weakSelf.viewModelError = error;
        } completed:^{
            NSIndexPath *idxPathForStory = [self indexPathOfItem:story inArrayInsertionDeletion:self.latestStoriesUpdate];
            NSIndexSet *idxPathsRemoved = [self indexSetFromIndexPaths:@[idxPathForStory]];
            [weakSelf.latestStoriesUpdate removeIndexesFromArray:idxPathsRemoved];
        }];
        return nil;
    }];
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

- (BOOL)canLoadMoreStories
{
    return NO;
}
@end
