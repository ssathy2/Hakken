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

@interface DDDCommentsViewModel()
@property (strong, nonatomic) DDDArrayInsertionDeletion *latestComments;

@property (strong, nonatomic) DDDStoryTransitionModel *transitionModel;
@property (strong, nonatomic) NSMutableArray *commentTreeInfos;
@end

@implementation DDDCommentsViewModel

- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    DDDStoryTransitionModel *transitionModel = (DDDStoryTransitionModel *)model;
    self.transitionModel = transitionModel;
}

- (DDDHackerNewsItem *)story
{
    return self.transitionModel.story;
}

- (void)viewModelDidLoad
{
    [super viewModelDidLoad];
    
    __weak typeof(self) weakSelf = self;
    RACSignal *fetchComments = [[DDDDataServices sharedInstance] fetchCommentsForStoryIdentifier:@(self.transitionModel.story.id)];
    fetchComments = [fetchComments filter:^BOOL(id value) {
        return value != nil;
    }];
    fetchComments = [fetchComments flattenMap:^RACStream *(id value) {
        NSIndexSet *inserted = nil;
        if (value)
            inserted = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [value count])];
        return [RACSignal return:[self updateWithComments:value indexesInserted:inserted indexesDeleted:nil]];
    }];
    [fetchComments subscribeNext:^(id x) {
        [weakSelf formCommentTreeInfosArrayWithComments:[x array]];
        weakSelf.latestComments = x;
    }];
}

- (void)formCommentTreeInfosArrayWithComments:(NSArray *)comments
{
    if (!self.commentTreeInfos)
        self.commentTreeInfos = [NSMutableArray array];
 
    NSInteger depth = 0;
    for (DDDHackerNewsComment *comment in comments)
        [self formCommentTreeWithRootComment:comment withDepth:depth];
}
                                      
- (void)formCommentTreeWithRootComment:(DDDHackerNewsComment *)rootComment withDepth:(NSInteger)depth
{
    if (![self shouldIgnoreComment:rootComment])
        [self.commentTreeInfos addObject:[DDDCommentTreeInfo commentTreeInfoWithComment:rootComment withDepth:depth]];
    
    if (!rootComment.kids)
        return;
    for (DDDHackerNewsComment *childComment in rootComment.kids)
    {
        depth++;
        [self formCommentTreeWithRootComment:childComment withDepth:depth];
    }
}

- (BOOL)shouldIgnoreComment:(DDDHackerNewsComment *)comment
{
    return comment.deleted;
}

- (DDDHackerNewsComment *)commentForRootItemIndex:(NSInteger)rootItemIndex forDepth:(NSInteger)depth
{
    return (DDDHackerNewsComment *)[self.commentTreeInfos[rootItemIndex] comment];
}

- (DDDCommentTreeInfo *)commentTreeInfoForIndexPath:(NSIndexPath *)idxPath
{
    if (self.commentTreeInfos.count == 0)
        return nil;
    return [self.commentTreeInfos objectAtIndex:idxPath.row];
}

- (NSInteger)commentCount
{
    return [self.commentTreeInfos count];
}

- (DDDArrayInsertionDeletion *)updateWithComments:(NSArray *)comments indexesInserted:(NSIndexSet *)indexesInserted indexesDeleted:(NSIndexSet *)indexesDeleted
{
    DDDArrayInsertionDeletion *topStoresUpdate = [DDDArrayInsertionDeletion new];
    topStoresUpdate.array = comments;
    topStoresUpdate.indexesDeleted = indexesDeleted;
    topStoresUpdate.indexesInserted = indexesInserted;
    return topStoresUpdate;
}

@end
