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

#define DDDTopStoriesRefreshFetchCount  20
#define DDDMaxTopStoriesCount           500

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
    self.topStoryToValue   = DDDTopStoriesRefreshFetchCount;
}

- (void)viewModelDidLoad
{
    [super viewModelDidLoad];
    
    __block NSArray *results;
    [[self fetchStoriesFrom:self.topStoryFromValue to:self.topStoryToValue] subscribeNext:^(id x) {
        results = x;
    } error:^(NSError *error) {
        self.viewModelError = error;
    } completed:^{
        [self.latestStoriesUpdate addAllItemsIntoArrayFromArray:results];
    }];
}

- (void)viewModelWillAppear
{
    [super viewModelWillAppear];
    
    if (!self.isFetchingStories)
    {
        __block NSArray *results;
        [[self fetchReadSavedStories] subscribeNext:^(id x) {
            results = x;
        } completed:^{
            [self.latestStoriesUpdate updateItemsAtIndexes:[self indexSetWithItems:results inAllItems:self.latestStoriesUpdate.array] withItems:results];
        }];
    }
}

- (NSIndexSet *)indexSetWithItems:(NSArray *)items inAllItems:(NSArray *)allItems
{
    NSMutableIndexSet *mutableIndexSet = [NSMutableIndexSet new];
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSUInteger idxOfObj = [allItems indexOfObjectIdenticalTo:obj];
        if (idxOfObj != NSNotFound)
            [mutableIndexSet addIndex:idxOfObj];
    }];
    return mutableIndexSet;
}

- (void)refreshCurrentBatchOfStories
{
    __block NSArray *results;
    [[self fetchStoriesFrom:self.topStoryFromValue to:self.topStoryToValue] subscribeNext:^(id x) {
        results = x;
    } error:^(NSError *error) {
        self.viewModelError = error;
    } completed:^{
        [self.latestStoriesUpdate resetArrayWithArray:results];
    }];
}

- (RACSignal *)fetchStoriesFrom:(NSInteger)from to:(NSInteger)to
{
    self.isFetchingStories = YES;
    RACSignal *fetchTopStories = [[DDDDataServices sharedInstance] fetchTopStoriesFromStory:@(from) toStory:@(to)];
    fetchTopStories = [fetchTopStories filter:^BOOL(id value) {
        return value != nil;
    }];
    return [fetchTopStories then:^RACSignal *{
        self.isFetchingStories = NO;
        return fetchTopStories;
    }];
}

- (void)fetchNextBatchOfStories
{
    self.topStoryFromValue = self.topStoryToValue+1;
    self.topStoryToValue += (DDDTopStoriesRefreshFetchCount+1);
    __block NSArray *results;
    
    [[self fetchStoriesFrom:self.topStoryFromValue to:self.topStoryToValue] subscribeNext:^(id x) {
        results = x;
    } error:^(NSError *error) {
        self.viewModelError = error;
    } completed:^{
        [self.latestStoriesUpdate addAllItemsIntoArrayFromArray:results];
    }];
}
     
- (RACSignal *)fetchReadSavedStories
{
    return [DDDHakkenReadLaterManager fetchReadReadLaterItems];
}

- (RACSignal *)fetchUnreadSavedStories
{
    return [DDDHakkenReadLaterManager fetchUnreadReadLaterItems];
}

- (RACSignal *)fetchAllSavedStories
{
    return [DDDHakkenReadLaterManager fetchAllItemsToReadLater];
}

- (BOOL)canLoadMoreStories
{
    return (self.topStoryToValue < DDDMaxTopStoriesCount);
}
@end
