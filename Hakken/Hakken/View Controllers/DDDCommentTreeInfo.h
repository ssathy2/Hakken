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
@property (strong, nonatomic) DDDHackerNewsComment *comment;
@property (nonatomic, assign) NSInteger depth;

+ (DDDCommentTreeInfo *)commentTreeInfoWithComment:(DDDHackerNewsComment *)comment withDepth:(NSInteger)depth;
@end
