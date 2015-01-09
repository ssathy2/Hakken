//
//  DDDTopStoriesViewModel.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDStoryDisplayViewModel.h"

@class DDDArrayInsertionDeletion;

@interface DDDTopStoriesViewModel : DDDStoryDisplayViewModel
- (void)fetchNextStories:(NSNumber *)numberToFetch;
@end
