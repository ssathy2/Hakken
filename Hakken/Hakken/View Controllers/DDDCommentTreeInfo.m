//
//  DDDCommentTreeInfo.m
//  Hakken
//
//  Created by Sidd Sathyam on 12/25/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDCommentTreeInfo.h"

@implementation DDDCommentTreeInfo
+ (DDDCommentTreeInfo *)commentTreeInfoWithComment:(DDDHackerNewsComment *)comment withDepth:(NSInteger)depth
{
    DDDCommentTreeInfo *commentTreeInfo = [DDDCommentTreeInfo new];
    commentTreeInfo.comment = comment;
    commentTreeInfo.depth = depth;
    return commentTreeInfo;
}
@end
