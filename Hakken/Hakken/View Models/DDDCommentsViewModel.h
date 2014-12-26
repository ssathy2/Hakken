//
//  DDDCommentsViewModel.h
//  Hakken
//
//  Created by Sidd Sathyam on 12/25/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewModel.h"

@class DDDArrayInsertionDeletion, DDDHackerNewsComment, DDDCommentTreeInfo;

@interface DDDCommentsViewModel : DDDViewModel
@property (strong, nonatomic) DDDArrayInsertionDeletion *latestComments;

- (DDDHackerNewsComment *)commentForRootItemIndex:(NSInteger)rootItemIndex forDepth:(NSInteger)depth;
- (DDDCommentTreeInfo *)commentTreeInfoForIndexPath:(NSIndexPath *)idxPath;
- (NSInteger)commentCount;
@end
