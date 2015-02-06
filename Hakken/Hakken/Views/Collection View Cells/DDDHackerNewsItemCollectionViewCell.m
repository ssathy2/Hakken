//
//  DDDHackerNewsItemCollectionViewCell.m
//  Hakken
//
//  Created by Sidd Sathyam on 12/1/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDHackerNewsItemCollectionViewCell.h"
#import "DDDHackerNewsItem.h"

@interface DDDHackerNewsItemCollectionViewCell()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UILabel *pointDatePostedLabel;
@property (weak, nonatomic) IBOutlet UIButton *readLaterButton;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// Constraints Outlets
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *urlToPointsHoursVerticalSpacing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleToUrlLabelVerticalSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *urlLabelHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonToContainerHorizontalSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLengthWidthConstraint;

@end

@implementation DDDHackerNewsItemCollectionViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.commentsButton.hidden = self.urlLabel.hidden = NO;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self styleCell];
}

- (void)styleCell
{
    self.commentsButton.layer.masksToBounds = NO;
    [self.commentsButton.layer setCornerRadius:self.commentsButton.frame.size.height/2];
}

- (IBAction)didTouchDownOnCommentButton:(UIButton *)sender
{
    [UIView animateWithDuration:0.2
                          delay:0.f
         usingSpringWithDamping:0.7f
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            self.commentsButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
                        } completion:nil];
}

- (IBAction)resetButtonTransform:(id)sender
{
    [UIView animateWithDuration:0.2
                          delay:0.f
         usingSpringWithDamping:0.2f
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            self.commentsButton.transform = CGAffineTransformMakeScale(1.f, 1.f);
                        } completion:nil];
}

- (IBAction)didTouchUpOnCommentButton:(UIButton *)sender
{
    [UIView animateWithDuration:0.2
                          delay:0.f
         usingSpringWithDamping:0.2f
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            self.commentsButton.transform = CGAffineTransformMakeScale(1.f, 1.f);
                        } completion:^(BOOL finished) {
                            if (finished)
                            {
                                if ([self.delegate respondsToSelector:@selector(cell:didSelectCommentsButton:)])
                                    [self.delegate cell:self didSelectCommentsButton:self.model];
                            }
                        }];
}

- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    
    DDDHackerNewsItem *hnItem = (DDDHackerNewsItem *)model;
    self.userName.text = [NSString stringWithFormat:@"from %@", hnItem.by];
    
    self.pointDatePostedLabel.text = [NSString stringWithFormat:@"%@ %@ - %@", @(hnItem.score), (hnItem.score > 1) ? @"points" : @"point", [[hnItem dateCreated] relativeDateTimeStringToNow]];
    self.titleLabel.text = hnItem.title;
    
    [self styleURLLabelWithHackernewsItem:hnItem];
    
    // TODO: Get the actual number of comments
    [self.commentsButton setTitle:[@(hnItem.kids.count) stringValue] forState:UIControlStateNormal];
}

- (void)styleURLLabelWithHackernewsItem:(DDDHackerNewsItem *)item
{
    if (item.isItemUserGenerated)
        self.urlLabel.hidden = YES;
    
    if (item.itemType == DDDHackerNewsItemTypeJob)
        self.commentsButton.hidden = YES;
    
    self.urlLabel.text = [NSString stringWithFormat:@"(%@)", [item.itemURL host]];
}

- (IBAction)readLaterButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cell:didSelectAddToReadLater:)])
        [self.delegate cell:self didSelectAddToReadLater:self.model];
}
@end