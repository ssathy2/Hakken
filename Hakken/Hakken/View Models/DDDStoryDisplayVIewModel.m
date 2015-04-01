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
@property (strong, nonatomic) RACSignal *unreadStoriesSignal;
@end

@implementation DDDStoryDisplayViewModel
- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    self.latestStoriesUpdate = [DDDArrayInsertionDeletion new];
}

- (RACSignal *)saveStoryToReadLater:(DDDHackerNewsItem *)story;
{
    return [[DDDHakkenReadLaterManager addItemToReadLater:story] then:^RACSignal *{
        return [self fetchUnreadStories];
    }];
}

- (RACSignal *)removeStoryFromReadLater:(DDDHackerNewsItem *)story
{
    return [[DDDHakkenReadLaterManager removeItemFromReadLater:story] then:^RACSignal *{
        return [self fetchUnreadStories];
    }];
}

- (RACSignal *)fetchUnreadStories
{
    if (!_unreadStoriesSignal)
    {
        _unreadStoriesSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            return [[DDDHakkenReadLaterManager fetchUnreadReadLaterItems] subscribe:subscriber];
        }];
    }
    return _unreadStoriesSignal;
}

- (BOOL)canLoadMoreStories
{
    return NO;
}

@end
