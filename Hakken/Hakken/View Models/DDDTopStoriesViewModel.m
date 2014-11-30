//
//  DDDTopStoriesViewModel.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDTopStoriesViewModel.h"
#import "DDDReactiveServices.h"
#import "DDDArrayInsertionDeletion.h"

@interface DDDTopStoriesViewModel()
@property (strong, nonatomic) NSNumber *topStoryFromValue;
@property (strong, nonatomic) NSNumber *topStoryToValue;
@end

@implementation DDDTopStoriesViewModel
- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    self.topStoryFromValue = @(0);
    self.topStoryToValue   = @(20);
}

- (void)viewModelDidLoad
{
    [super viewModelDidLoad];

    RACSignal *fetchTopStories = [[DDDReactiveServices sharedInstance] fetchTopStoriesFromStory:self.topStoryFromValue toStory:self.topStoryToValue];
    fetchTopStories = [fetchTopStories filter:^BOOL(id value) {
        return value != nil;
    }];
    fetchTopStories = [fetchTopStories flattenMap:^RACStream *(id value) {
        NSIndexSet *inserted = nil;
        if (value)
            inserted = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [value count])];
        return [RACSignal return:[self updateWithStories:(NSArray *)value indexesInserted:inserted indexesDeleted:nil]];
    }];
    [fetchTopStories subscribeNext:^(id x) {
        self.latestTopStoriesUpdate = x;
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

- (void)fetchNextStories:(NSNumber *)numberToFetch
{
    
}
@end
