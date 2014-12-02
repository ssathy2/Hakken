//
//  DDDStoryDetailCollectionViewCell.m
//  Hakken
//
//  Created by Sidd Sathyam on 12/1/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDStoryDetailCollectionViewCell.h"
#import "DDDHackerNewsItem.h"

@implementation DDDStoryDetailCollectionViewCell
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self styleCell];
}
- (void)styleCell
{
    self.commentsButton.layer.masksToBounds = NO;
    [self.commentsButton.layer setCornerRadius:self.commentsButton.frame.size.height];
}

// TODO: Implement this method to properly return the correctly sized cell
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    UICollectionViewLayoutAttributes *retAttributes = [layoutAttributes copy];
    CGRect fittingCellFrame = layoutAttributes.frame;
    CGFloat prevTitleLabelHeight = self.titleLabel.bounds.size.height;
    [self.titleLabel sizeToFit];
    CGFloat heightDiff = self.titleLabel.bounds.size.height - prevTitleLabelHeight;
    
    if (heightDiff > 0)
        fittingCellFrame.size.height += heightDiff;
    
    retAttributes.frame = fittingCellFrame;
    return retAttributes;
}

- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    
    DDDHackerNewsItem *hnItem = (DDDHackerNewsItem *)model;
    self.titleLabel.text = hnItem.title;

    // TODO: Get the actual number of comments
    [self.commentsButton setTitle:[@(hnItem.kids.count) stringValue] forState:UIControlStateNormal];
    [self.webview loadRequest:[NSURLRequest requestWithURL:hnItem.itemURL]];
}
@end
