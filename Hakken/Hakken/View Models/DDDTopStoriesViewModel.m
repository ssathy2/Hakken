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
    self.topStoryToValue   = 10;
}

- (void)viewModelDidLoad
{
    [super viewModelDidLoad];
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
        if (value)
            inserted = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(from, to)];
        return [RACSignal return:[self updateWithStories:(NSArray *)value indexesInserted:inserted indexesDeleted:nil]];
    }];
    [fetchTopStories subscribeNext:^(id x) {
        weakSelf.isFetchingStories = NO;
        weakSelf.latestStoriesUpdate = x;
    }];
}

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
        self.topStoryFromValue = self.topStoryToValue+1;
        self.topStoryToValue += DDDTopStoriesRefreshFetchCount;
        
        [self fetchStoriesFrom:self.topStoryFromValue to:self.topStoryToValue];
    }
}

@end
