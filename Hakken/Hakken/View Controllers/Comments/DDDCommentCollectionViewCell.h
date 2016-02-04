//
//  DDDCommentCollectionViewCell.h
//  Hakken
//
//  Created by Sidd Sathyam on 12/25/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDCollectionViewCell.h"

@class DDDCommentCollectionViewCell, DDDHackerNewsComment;

@protocol DDDCommentCollectionViewCellDelegate <NSObject>
- (void)commentCollectionViewCell:(DDDCommentCollectionViewCell *)cell didTapOnLinkInComment:(DDDHackerNewsComment *)comment withLink:(NSURL *)link;
@end

@interface DDDCommentCollectionViewCell : DDDCollectionViewCell
@property (weak, nonatomic) id<DDDCommentCollectionViewCellDelegate> delegate;

- (void)showCollapsedView;
- (void)showExpandedView;
- (NSURL *)tappedLinkInCell;
@end
