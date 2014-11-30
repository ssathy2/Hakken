//
//  DDDHackerNewsItem.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/20/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDModel.h"

typedef NS_ENUM(NSInteger, DDDHackerNewsItemType)
{
    DDDHackerNewsItemTypeJob,
    DDDHackerNewsItemTypeStory,
    DDDHackerNewsItemTypeComment,
    DDDHackerNewsItemTypePoll,
    DDDHackerNewsItemTypePollOption
};

@interface DDDHackerNewsItem : DDDModel
@property (copy,   nonatomic) NSNumber *identifier;
@property (assign, nonatomic) BOOL deleted;
@property (assign, nonatomic) DDDHackerNewsItemType type;
@property (copy,   nonatomic) NSString *by;
@property (copy,   nonatomic) NSNumber *time;
@property (copy,   nonatomic) NSString *text;
@property (assign, nonatomic) BOOL dead;
@property (copy,   nonatomic) NSString *parent;
@property (copy,   nonatomic) NSArray *kids;
@property (copy,   nonatomic) NSString *url;
@property (copy,   nonatomic) NSNumber *score;
@property (copy,   nonatomic) NSString *title;
@property (copy,   nonatomic) NSArray *parts;

// generated properties
@property (readonly, nonatomic) NSURL *itemURL;
@end
