//
//  DDDStoryDisplayVIewModel.m
//  Hakken
//
//  Created by Sidd Sathyam on 1/9/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "DDDStoryDisplayViewModel.h"
#import "DDDArrayInsertionDeletion.h"

@interface DDDStoryDisplayViewModel()
@end

@implementation DDDStoryDisplayViewModel
- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    self.latestStoriesUpdate = [DDDArrayInsertionDeletion new];
}

- (RACSignal *)saveStoryToReadLater:(DDDHackerNewsItem *)story;
{
    return [DDDHakkenReadLaterManager addItemToReadLater:story];
}

- (RACSignal *)removeStoryFromReadLater:(DDDHackerNewsItem *)story
{
    return [DDDHakkenReadLaterManager removeItemFromReadLater:story];
}

- (RACSignal *)markStoryAsRead:(DDDHackerNewsItem *)story
{
    return [DDDHakkenReadLaterManager markStoryAsRead:story];
}

- (RACSignal *)markStoryAsUnread:(DDDHackerNewsItem *)story
{
    return [DDDHakkenReadLaterManager markStoryAsUnread:story];
}


- (BOOL)canLoadMoreStories
{
    return NO;
}

@end
