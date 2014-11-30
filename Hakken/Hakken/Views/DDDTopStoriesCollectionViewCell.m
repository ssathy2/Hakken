//
//  DDDTopStoriesCollectionViewCell.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/26/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDTopStoriesCollectionViewCell.h"
#import "DDDHackerNewsItem.h"

@interface DDDTopStoriesCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UILabel *pointDatePostedLabel;

@property (weak, nonatomic) IBOutlet UIView *pageableContentView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation DDDTopStoriesCollectionViewCell

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
    self.userName.text = [NSString stringWithFormat:@"from %@", hnItem.by];
    
    NSURL *url = [NSURL URLWithString:hnItem.url];
    self.urlLabel.text = [NSString stringWithFormat:@"(%@)", [url host]];
    
    self.pointDatePostedLabel.text = [NSString stringWithFormat:@"%@ %@ %@", hnItem.score, (hnItem.score.integerValue > 1) ? @"points" : @"point", [[NSDate dateWithTimeIntervalSince1970:[hnItem.time doubleValue]] relativeDateTimeStringToNow]];
    self.titleLabel.text = hnItem.title;
    
    // TODO: Get the actual number of comments
    [self.commentsButton setTitle:[@(hnItem.kids.count) stringValue] forState:UIControlStateNormal];
}
@end
