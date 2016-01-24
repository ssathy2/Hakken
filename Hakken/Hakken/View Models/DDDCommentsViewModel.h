//
//  DDDCommentsViewModel.h
//  Hakken
//
//  Created by Sidd Sathyam on 12/25/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewModel.h"

@class DDDArrayInsertionDeletion, DDDHackerNewsComment, DDDCommentTreeInfo, DDDHackerNewsItem;

typedef void(^ArrayParameterBlock)( NSArray *);

@protocol DDDCommentsViewModelDelegate <NSObject>
@optional
@property (copy, nonatomic) ArrayParameterBlock indexPathsCollapsedBlock;
@property (copy, nonatomic) ArrayParameterBlock indexPathsExpandedBlock;
@end

@interface DDDCommentsViewModel : DDDViewModel
@property (strong, nonatomic, readonly) DDDArrayInsertionDeletion *latestComments;
@property (strong, nonatomic, readonly) DDDHackerNewsItem *story;
@property (weak, nonatomic) id<DDDCommentsViewModelDelegate> delegate;

- (DDDHackerNewsComment *)commentForRootItemIndex:(NSInteger)rootItemIndex forDepth:(NSInteger)depth;
- (DDDCommentTreeInfo *)commentTreeInfoForIndexPath:(NSIndexPath *)idxPath;
- (DDDCommentTreeInfo *)commentTreeInfoForComment:(DDDHackerNewsComment *)comment;
- (void)toggleChildCommentsExpandedCollapsedWithRootCommentAtIndexPath:(NSIndexPath *)idxPath;

- (RACSignal *)markStoryAsRead;
- (NSInteger)commentCount;

- (void)refreshComments;
- (BOOL)shouldShowLoadingFooter;
@end
