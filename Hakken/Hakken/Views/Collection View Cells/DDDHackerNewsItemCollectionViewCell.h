//
//  DDDHackerNewsItemCollectionViewCell.h
//  Hakken
//
//  Created by Sidd Sathyam on 12/1/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDCollectionViewCell.h"
#import "DDDHakkenReadLater.h"

#define DDDHackerNewsItemCollectionViewCellIdentifier @"DDDHackerNewsItemCollectionViewCell"

@class DDDHackerNewsItemCollectionViewCell, DDDHackerNewsItem;

@protocol DDDHackerNewsItemCollectionViewCellDelegate <NSObject>
@optional
- (void)cell:(DDDHackerNewsItemCollectionViewCell *)cell didSelectCommentsButton:(DDDHackerNewsItem *)story;
- (void)cell:(DDDHackerNewsItemCollectionViewCell *)cell didSelectAddToReadLater:(DDDHackerNewsItem *)story withCompletion:(DDDHackerNewsItemBlock)completion withError:(ErrorBlock)error;
- (void)cell:(DDDHackerNewsItemCollectionViewCell *)cell didSelectRemoveFromReadLater:(DDDHackerNewsItem *)story withCompletion:(DDDHackerNewsItemBlock)completion withError:(ErrorBlock)error;
@end

@interface DDDHackerNewsItemCollectionViewCell : DDDCollectionViewCell
@property (weak, nonatomic) id<DDDHackerNewsItemCollectionViewCellDelegate> delegate;

- (void)handlePanGesture:(UIPanGestureRecognizer *)pangestureRecognizer;
- (void)closeCellSwipeContainer;
@end
