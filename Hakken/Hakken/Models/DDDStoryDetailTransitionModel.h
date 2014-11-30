//
//  DDDStoryDetailTransitionModel.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/30/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDModel.h"

@class DDDHackerNewsItem;

typedef NS_ENUM(NSInteger, DDDStoryDetailView)
{
    DDDStoryDetailViewArticle,
    DDDStoryDetailViewComments
};

@interface DDDStoryDetailTransitionModel : DDDModel
@property (strong, nonatomic) UIView *topPeekView;
@property (strong, nonatomic) UIView *bottomPeekView;
@property (strong, nonatomic) DDDHackerNewsItem *story;

// Defaults to DDDStortDetailViewArticle
@property (assign, nonatomic) DDDStoryDetailView viewToDisplay;
@end
