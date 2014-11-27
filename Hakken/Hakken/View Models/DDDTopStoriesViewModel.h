//
//  DDDTopStoriesViewModel.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewModel.h"

@class DDDArrayInsertionDeletion;

@interface DDDTopStoriesViewModel : DDDViewModel
// This object gets updated with the latest stories array and any insertions and deletions that may have occurred
@property (strong, nonatomic) DDDArrayInsertionDeletion *latestTopStoriesUpdate;

- (void)fetchNextStories:(NSNumber *)numberToFetch;
@end
