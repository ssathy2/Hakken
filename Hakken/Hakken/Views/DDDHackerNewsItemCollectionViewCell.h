//
//  DDDHackerNewsItemCollectionViewCell.h
//  Hakken
//
//  Created by Sidd Sathyam on 12/1/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDCollectionViewCell.h"

#define DDDHackerNewsItemCollectionViewCellIdentifier @"DDDHackerNewsItemCollectionViewCell"

@class DDDHackerNewsItemCollectionViewCell, DDDHackerNewsItem;

@protocol DDDHackerNewsItemCollectionViewCellDelegate <NSObject>
- (void)cell:(DDDHackerNewsItemCollectionViewCell *)cell didSelectCommentsButton:(DDDHackerNewsItem *)story;
@end

@interface DDDHackerNewsItemCollectionViewCell : DDDCollectionViewCell
@property (weak, nonatomic) id<DDDHackerNewsItemCollectionViewCellDelegate> delegate;

+ (CGSize)adjustedCellSizeWithModel:(id)model;
@end
