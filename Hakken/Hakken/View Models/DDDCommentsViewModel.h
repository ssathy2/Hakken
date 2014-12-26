//
//  DDDCommentsViewModel.h
//  Hakken
//
//  Created by Sidd Sathyam on 12/25/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewModel.h"

@class DDDArrayInsertionDeletion, DDDHackerNewsComment;

@interface DDDCommentsViewModel : DDDViewModel
@property (strong, nonatomic) DDDArrayInsertionDeletion *latestComments;

- (NSInteger)totalCommentCount;
- (DDDHackerNewsComment *)commentForIndexPath:(NSIndexPath *)indexpath;
- (NSInteger)commentDepthForIndexPath:(NSIndexPath *)indexPath;
@end
