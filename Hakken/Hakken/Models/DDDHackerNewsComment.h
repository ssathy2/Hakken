//
//  DDDHackerNewsComment.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/20/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDHackerNewsItem.h"

@class DDDHackerNewsComment;
RLM_ARRAY_TYPE(DDDHackerNewsComment)

@interface DDDHackerNewsComment : RLMObject
@property (strong, nonatomic) RLMArray<DDDHackerNewsComment> *kids;
@property (assign, nonatomic) NSInteger id;
@property (copy, nonatomic) NSString *type;
@property (copy,   nonatomic) NSString *by;
@property (assign, nonatomic) double time;
@property (copy,   nonatomic) NSString *text;
@property (assign, nonatomic) double parent;
@property (assign, nonatomic) BOOL deleted;

@property (assign, nonatomic) BOOL isCollapsed;
@property (assign, nonatomic) BOOL areChildrenCollapsed;

// Generated and Ignored properties
@property (readonly, nonatomic) NSDate *dateCreated;
@property (assign, nonatomic) DDDHackerNewsItemType itemType;
@end
