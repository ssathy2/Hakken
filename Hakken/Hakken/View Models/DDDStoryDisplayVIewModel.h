//
//  DDDStoryDisplayVIewModel.h
//  Hakken
//
//  Created by Sidd Sathyam on 1/9/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "DDDViewModel.h"
#import "DDDHakkenReadLaterManager.h"

@class DDDArrayInsertionDeletion;

@interface DDDStoryDisplayViewModel : DDDViewModel
@property (strong, nonatomic) DDDArrayInsertionDeletion *latestStoriesUpdate;

- (RACSignal *)saveStoryToReadLater:(DDDHackerNewsItem *)story;
- (RACSignal *)removeStoryFromReadLater:(DDDHackerNewsItem *)story;

- (BOOL)canLoadMoreStories;
@end
