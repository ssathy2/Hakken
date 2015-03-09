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
    RACSignal *fetchTopStories = [[DDDDataServices sharedInstance] fetchTopStoriesFromStory:@(from) toStory:@(to)];
    fetchTopStories = [fetchTopStories filter:^BOOL(id value) {
        return value != nil;
    }];
    return fetchTopStories;
}

- (void)fetchNextBatchOfStories
{
    self.topStoryFromValue = self.topStoryToValue+1;
    self.topStoryToValue += DDDTopStoriesRefreshFetchCount;
    __block NSArray *results;
    
    [[self fetchStoriesFrom:self.topStoryFromValue to:self.topStoryToValue] subscribeNext:^(id x) {
        results = x;
    } error:^(NSError *error) {
        self.viewModelError = error;
    } completed:^{
        [self.latestStoriesUpdate addAllItemsIntoArrayFromArray:results];
    }];
}

- (BOOL)canLoadMoreStories
{
    return (self.topStoryToValue < DDDMaxTopStoriesCount);
}
@end
