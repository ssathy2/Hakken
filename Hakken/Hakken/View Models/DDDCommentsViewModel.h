//
//  DDDCommentsViewModel.h
//  Hakken
//
//  Created by Sidd Sathyam on 12/25/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewModel.h"

@class DDDArrayInsertionDeletion, DDDHackerNewsComment, DDDCommentTreeInfo, DDDHackerNewsItem;

@interface DDDCommentsViewModel : DDDViewModel
@property (strong, nonatomic, readonly) DDDArrayInsertionDeletion *latestComments;
@property (strong, nonatomic, readonly) DDDHackerNewsItem *story;

- (DDDHackerNewsComment *)commentForRootItemIndex:(NSInteger)rootItemIndex forDepth:(NSInteger)depth;
- (DDDCommentTreeInfo *)commentTreeInfoForIndexPath:(NSIndexPath *)idxPath;
- (NSInteger)commentCount;

- (void)refreshComments;
- (BOOL)shouldShowLoadingFooter;
@end
