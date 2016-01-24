//
//  DDDCommentTreeInfo.h
//  Hakken
//
//  Created by Sidd Sathyam on 12/25/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDModel.h"

@class DDDHackerNewsComment;

@interface DDDCommentTreeInfo : DDDModel
@property (nonatomic, strong) DDDHackerNewsComment *comment;
@property (nonatomic, assign) NSInteger depth;
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (DDDCommentTreeInfo *)commentTreeInfoWithComment:(DDDHackerNewsComment *)comment withDepth:(NSInteger)depth;
@end
