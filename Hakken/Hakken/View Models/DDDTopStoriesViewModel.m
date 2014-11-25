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
// This object gets updated with the latest stories array and any insertions and deletions that may have occurred
@property (strong, nonatomic) DDDArrayInsertionDeletion *latestTopStoriesUpdate;

@property (strong, nonatomic) NSNumber *topStoryFromValue;
@property (strong, nonatomic) NSNumber *topStoryToValue;
@end

@implementation DDDTopStoriesViewModel
- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    self.topStoryFromValue = @(0);
    self.topStoryToValue   = @(10);
}

- (void)viewModelDidLoad
{
    [super viewModelDidLoad];
    
    __weak typeof(self) weakSelf = self;
    RACSignal *fetchTopStories = [[DDDReactiveServices sharedInstance] fetchTopStoriesFromStory:self.topStoryFromValue toStory:self.topStoryToValue];
    fetchTopStories = [fetchTopStories filter:^BOOL(id value) {
        return value != nil;
    }];
    [fetchTopStories subscribeNext:^(NSArray *stories) {
        if (stories.count != 0)
            [weakSelf updateWithStories:stories indexesInserted:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, stories.count-1)] indexesDeleted:nil];
    } error:^(NSError *error) {
        DDLogError(@"%@", error);
    } completed:^{
       
    }];
}

- (void)updateWithStories:(NSArray *)stories indexesInserted:(NSIndexSet *)indexesInserted indexesDeleted:(NSIndexSet *)indexesDeleted
{
    if (!self.latestTopStoriesUpdate)
        self.latestTopStoriesUpdate = [DDDArrayInsertionDeletion new];
    
    self.latestTopStoriesUpdate = [DDDArrayInsertionDeletion new];
    self.latestTopStoriesUpdate.array = stories;
    self.latestTopStoriesUpdate.indexesDeleted = indexesDeleted;
    self.latestTopStoriesUpdate.indexesInserted = indexesInserted;
}

- (void)fetchNextStories:(NSNumber *)numberToFetch
{
    
}
@end
