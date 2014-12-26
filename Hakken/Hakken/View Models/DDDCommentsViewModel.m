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

@interface DDDCommentsViewModel()
@property (strong, nonatomic) DDDStoryTransitionModel *transitionModel;
@end

@implementation DDDCommentsViewModel

- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    DDDStoryTransitionModel *transitionModel = (DDDStoryTransitionModel *)model;
    self.transitionModel = transitionModel;
}

- (void)viewModelDidLoad
{
    [super viewModelDidLoad];
    
    __weak typeof(self) weakSelf = self;
    RACSignal *fetchComments = [[DDDDataServices sharedInstance] fetchCommentsForStoryIdentifier:self.transitionModel.story.identifier];
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
        weakSelf.latestComments = x;
    }];
}

- (NSInteger)totalCommentCount
{
    NSInteger count = 0;
    for (DDDHackerNewsComment *comment in self.latestComments.array)
    {
        count += [self totalCommentCountWithComment:comment];
    }
    return count;
}

- (NSInteger)totalCommentCountWithComment:(DDDHackerNewsComment *)comment
{
    if (!comment.kids)
        return 0;
    NSInteger count = 0;
    for (DDDHackerNewsComment *commentKid in comment.kids)
    {
        count = comment.kids.count + [self totalCommentCountWithComment:commentKid];
    }
    return count;
}

// TODO: Implement
- (DDDHackerNewsComment *)commentForIndexPath:(NSIndexPath *)indexpath
{
    return self.latestComments.array[indexpath.row % self.latestComments.array.count];
}

// TODO: Implement
- (NSInteger)commentDepthForIndexPath:(NSIndexPath *)indexPath
{
    return 0;
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
