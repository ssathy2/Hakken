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
    DDDHackerNewsItemTypeUndetermined,
    DDDHackerNewsItemTypeJob,
    DDDHackerNewsItemTypeStory,
    DDDHackerNewsItemTypeComment,
    DDDHackerNewsItemTypePoll,
    DDDHackerNewsItemTypePollOption
};

// UGH WHAT A STUPID UGLY HACK...I NEED TO DO THIS TO BE ABLE TO STORE AN ARRAY OF STRINGS ON A RLMOBJECT
@interface RLMNumberObject : RLMObject
@property (strong, nonatomic) NSString *identifier;
@end

@class DDDHackerNewsItem, DDDHakkenReadLaterInformation;
RLM_ARRAY_TYPE(DDDHackerNewsItem);
RLM_ARRAY_TYPE(RLMNumberObject);

@interface DDDHackerNewsItem : RLMObject
@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) BOOL deleted;
@property (copy, nonatomic) NSString *type;
@property (copy,   nonatomic) NSString *by;
@property (assign, nonatomic) double time;
@property (copy,   nonatomic) NSString *text;
@property (assign, nonatomic) BOOL dead;
@property (assign,   nonatomic) double parent;
@property (strong, nonatomic) RLMArray<RLMNumberObject> *kids;
@property (copy,   nonatomic) NSString *url;
@property (assign, nonatomic) NSInteger score;
@property (copy,   nonatomic) NSString *title;
@property (strong,   nonatomic) RLMArray<DDDHackerNewsItem> *parts;

// Generated and Ignored properties
@property (readonly, nonatomic) NSDate *dateCreated;
@property (readonly, nonatomic) NSURL *itemURL;
@property (assign, nonatomic) DDDHackerNewsItemType itemType;

@property (strong, nonatomic) DDDHakkenReadLaterInformation *readLaterInformation;
@end
