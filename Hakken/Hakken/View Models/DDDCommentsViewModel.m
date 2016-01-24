//
//  DDDCommentsViewModel.m
//  Hakken
//
//  Created by Sidd Sathyam on 12/25/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDCommentsViewModel.h"
#import "DDDStoryTransitionModel.h"
#import "DDDDataServices.h"
#import "DDDHackerNewsItem.h"
#import "DDDArrayInsertionDeletion.h"
#import "DDDHackerNewsComment.h"
#import "DDDCommentTreeInfo.h"
#import "DDDHakkenReadLaterManager.h"

@interface DDDCommentsViewModel()
@property (strong, nonatomic) DDDArrayInsertionDeletion *latestComments;
@property (strong, nonatomic) DDDStoryTransitionModel *transitionModel;
@property (strong, nonatomic) NSMutableArray *commentTreeInfos;
@property (strong, nonatomic) NSMutableDictionary *collapsedComments; // a mapping of indexpath -> comment tree info
@end

@implementation DDDCommentsViewModel

- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    self.collapsedComments = [NSMutableDictionary dictionary];
    self.latestComments = [DDDArrayInsertionDeletion new];
    DDDStoryTransitionModel *transitionModel = (DDDStoryTransitionModel *)model;
    self.transitionModel = transitionModel;
}

- (RACSignal *)markStoryAsRead
{
    if (self.story.isUserGenerated)
        return [DDDHakkenReadLaterManager markStoryAsRead:self.story];
    else return nil;
}

- (DDDHackerNewsItem *)story
{
    return self.transitionModel.story;
}

- (void)viewModelDidLoad
{
    [super viewModelDidLoad];
    [self refreshComments];
}

- (void)formCommentTreeInfosArrayWithComments:(NSArray *)comments
{
    self.commentTreeInfos = [NSMutableArray array];
 
    NSInteger depth = 0;
    for (DDDHackerNewsComment *comment in comments)
        [self formCommentTreeWithRootComment:comment withDepth:depth];
}
                                      
- (void)formCommentTreeWithRootComment:(DDDHackerNewsComment *)rootComment withDepth:(NSInteger)depth
{
    if (!rootComment.kids)
        return;
    
    if (![self shouldIgnoreComment:rootComment])
    {
        DDDCommentTreeInfo *treeInfo = [DDDCommentTreeInfo new];
        treeInfo.comment = rootComment;
        treeInfo.depth = depth;
        // TODO: Remove this hard-coded section here...
        treeInfo.indexPath = [NSIndexPath indexPathForRow:self.commentTreeInfos.count inSection:0];
        [self.commentTreeInfos addObject:treeInfo];
    }

    for (DDDHackerNewsComment *childComment in rootComment.kids)
    {
        depth++;
        [self formCommentTreeWithRootComment:childComment withDepth:depth];
    }
}

- (void)toggleChildCommentsExpandedCollapsedWithRootCommentAtIndexPath:(NSIndexPath *)idxPath
{
    DDDCommentTreeInfo *info = [self commentTreeInfoForIndexPath:idxPath];
    [[RLMRealm defaultRealm] beginWriteTransaction];
    info.comment.areChildrenCollapsed = !info.comment.areChildrenCollapsed;
    [[RLMRealm defaultRealm] addOrUpdateObject:info.comment];
    if (info.comment.areChildrenCollapsed)
        [self collapseChildCommentsAtIndexPath:idxPath];
    else
        [self expandChildCommentsAtIndexPath:idxPath];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

- (NSIndexSet *)indexSetFromIndexPaths:(NSArray *)indexPaths
{
    NSMutableIndexSet *idxSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *idxPath in indexPaths)
        [idxSet addIndex:idxPath.row];
    return idxSet;
}

// grab the index paths that we should remove from the all comment tree infos...
// store this somewhere, and then update the collection view with these indexpaths that we're removing
- (void)collapseChildCommentsAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *childIndexPaths = [self indexPathsForChildrenOfCommentStartingAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    for (NSIndexPath *idxPath in childIndexPaths)
        self.collapsedComments[@(idxPath.row)] = self.latestComments.array[idxPath.row];
    
    if (self.delegate.indexPathsCollapsedBlock)
        self.delegate.indexPathsCollapsedBlock(childIndexPaths);
}

// grab the index paths that we should add from the all comment tree infos...
// reinsert this and then update the collection view with these indexpaths that we're adding...
- (void)expandChildCommentsAtIndexPath:(NSIndexPath *)indexPath
{

}

- (NSArray *)indexPathsForChildrenOfCommentsStartingAtIndexPath_Helper:(NSIndexPath *)indexPath
{
    DDDCommentTreeInfo *info = [self commentTreeInfoForIndexPath:indexPath];
    if (!info)
        return [NSArray new];
    
    info.comment.isCollapsed = !info.comment.isCollapsed;
    info.comment.areChildrenCollapsed = info.comment.areChildrenCollapsed;

    [[RLMRealm defaultRealm] addOrUpdateObject:info.comment];

    if (info.comment.kids.count == 0)
        return @[info.indexPath];
    
    NSMutableArray *idxPaths = [NSMutableArray array];
    [idxPaths addObject:info.indexPath];
    for (DDDHackerNewsComment *comment in info.comment.kids)
    {
        NSArray *recursiveCallArr = [self indexPathsForChildrenOfCommentsStartingAtIndexPath_Helper:[self commentTreeInfoForComment:comment].indexPath];
        if (recursiveCallArr.count > 0)
            [idxPaths addObjectsFromArray:recursiveCallArr];
    }
    
    return idxPaths;
}

- (NSArray *)indexPathsForChildrenOfCommentStartingAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *idxPaths = [NSMutableArray array];
    DDDCommentTreeInfo *info = [self commentTreeInfoForIndexPath:indexPath];

    info.comment.isCollapsed = !info.comment.isCollapsed;
    info.comment.areChildrenCollapsed = info.comment.areChildrenCollapsed;
    
    [[RLMRealm defaultRealm] addOrUpdateObject:info.comment];

    if (!info || info.comment.kids.count == 0)
        return [NSArray new];
    
    for (DDDHackerNewsComment *comment in info.comment.kids)
    {
        NSArray *recursiveCallArr = [self indexPathsForChildrenOfCommentsStartingAtIndexPath_Helper:[self commentTreeInfoForComment:comment].indexPath];
        if (recursiveCallArr.count > 0)
            [idxPaths addObjectsFromArray:recursiveCallArr];
    }
    
    return idxPaths;
}

- (BOOL)shouldIgnoreComment:(DDDHackerNewsComment *)comment
{
    return comment.deleted;
}

- (DDDHackerNewsComment *)commentForRootItemIndex:(NSInteger)rootItemIndex forDepth:(NSInteger)depth
{
    return (DDDHackerNewsComment *)[self.latestComments.array[rootItemIndex] comment];
}

- (DDDCommentTreeInfo *)commentTreeInfoForIndexPath:(NSIndexPath *)idxPath
{
    if (self.latestComments.array.count == 0)
        return nil;
    return [self.latestComments.array objectAtIndex:idxPath.row];
}

- (DDDCommentTreeInfo *)commentTreeInfoForComment:(DDDHackerNewsComment *)comment
{
    if (self.latestComments.array.count == 0)
        return nil;
    
    for (DDDCommentTreeInfo *commentTreeInfo in self.latestComments.array)
    {
        if (commentTreeInfo.comment.id == comment.id)
            return commentTreeInfo;
    }
    
    return nil;
}

- (NSInteger)commentCount
{
    return self.latestComments.array.count;
}

- (void)refreshComments
{
    __weak typeof(self) weakSelf = self;
    RACSignal *fetchComments = [[DDDDataServices sharedInstance] fetchCommentsForStoryIdentifier:@(self.transitionModel.story.id)];
    fetchComments = [fetchComments filter:^BOOL(id value) {
        return value != nil;
    }];
    
    __block NSArray *comments;
    [fetchComments subscribeNext:^(id x) {
        comments = x;
    } error:^(NSError *error) {
        weakSelf.viewModelError = error;
    } completed:^{
        [weakSelf formCommentTreeInfosArrayWithComments:comments];
        [weakSelf.latestComments resetArrayWithArray:weakSelf.commentTreeInfos];
    }];
}

- (BOOL)shouldShowLoadingFooter
{
    return (self.latestComments.array.count == 0);
}
@end
