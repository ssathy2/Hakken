//
//  DDDTopStoriesViewModel.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDTopStoriesViewModel.h"
#import "DDDDataServices.h"
#import "DDDArrayInsertionDeletion.h"

#define DDDTopStoriesRefreshFetchCount 20

@interface DDDTopStoriesViewModel()
@property (assign, nonatomic) NSInteger topStoryFromValue;
@property (assign, nonatomic) NSInteger topStoryToValue;

@property (assign, nonatomic) BOOL isFetchingStories;
@end

@implementation DDDTopStoriesViewModel
- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    self.isFetchingStories = NO;
    self.topStoryFromValue = 0;
    self.topStoryToValue   = 20;
}

- (void)viewModelDidLoad
{
    [super viewModelDidLoad];
    [self fetchStoriesFrom:self.topStoryFromValue to:self.topStoryToValue];
}

- (void)refreshCurrentBatchOfStories
{
    [self fetchStoriesFrom:self.topStoryFromValue to:self.topStoryToValue];
}

- (void)fetchStoriesFrom:(NSInteger)from to:(NSInteger)to
{
    __weak typeof(self) weakSelf = self;
    self.isFetchingStories = YES;
    RACSignal *fetchTopStories = [[DDDDataServices sharedInstance] fetchTopStoriesFromStory:@(from) toStory:@(to)];
    fetchTopStories = [fetchTopStories filter:^BOOL(id value) {
        return value != nil;
    }];
    fetchTopStories = [fetchTopStories flattenMap:^RACStream *(id value) {
        NSIndexSet *inserted = nil;
        NSIndexSet *deleted = nil;
        if (value)
            inserted = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(from, to)];
    
        return [RACSignal return:[self updateWithStories:(NSArray *)value indexesInserted:inserted indexesDeleted:deleted]];
    }];
    
    __block DDDArrayInsertionDeletion *arrayInsertion;
    [fetchTopStories subscribeNext:^(id x) {
        arrayInsertion = x;
    } error:^(NSError *error) {
        weakSelf.viewModelError = error;
    } completed:^{
        weakSelf.latestStoriesUpdate = arrayInsertion;
//        weakSelf.latestStoriesUpdate = [self mergeRecentArrayInsertionDeletion:arrayInsertion withExistingArrayInsertionDeletion:weakSelf.latestStoriesUpdate];
        weakSelf.isFetchingStories = NO;
    }];
}

//- (DDDArrayInsertionDeletion *)mergeRecentArrayInsertionDeletion:(DDDArrayInsertionDeletion *)recentArrayInsertionDeletion withExistingArrayInsertionDeletion:(DDDArrayInsertionDeletion *)existingArrayInsertionDeletion
//{
//    
//}

- (DDDArrayInsertionDeletion *)updateWithStories:(NSArray *)stories indexesInserted:(NSIndexSet *)indexesInserted indexesDeleted:(NSIndexSet *)indexesDeleted
{
    DDDArrayInsertionDeletion *topStoresUpdate = [DDDArrayInsertionDeletion new];
    topStoresUpdate.array = stories;
    topStoresUpdate.indexesDeleted = indexesDeleted;
    topStoresUpdate.indexesInserted = indexesInserted;
    return topStoresUpdate;
}

- (void)fetchNextBatchOfStories
{
    if (!self.isFetchingStories)
    {
        if (self.topStoryFromValue != 0)
        {
            self.topStoryFromValue = self.topStoryToValue+1;
            self.topStoryToValue += DDDTopStoriesRefreshFetchCount;
        }
        
        [self fetchStoriesFrom:self.topStoryFromValue to:self.topStoryToValue];
    }
}

@end
