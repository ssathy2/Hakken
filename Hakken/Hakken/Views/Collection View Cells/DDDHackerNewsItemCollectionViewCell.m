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


@property (weak, nonatomic) IBOutlet UIView *cellContentView;
@property (weak, nonatomic) IBOutlet UIView *swipeActionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellContentTrailingSpaceConstraint;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@end

@implementation DDDHackerNewsItemCollectionViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.commentsButton.hidden = self.urlLabel.hidden = NO;
    [self.cellContentView setFrame:self.contentView.bounds];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer)
    {
        UIPanGestureRecognizerDirection direction = [self.panGestureRecognizer panGestureDirectionInView:self.cellContentView];
        if ((direction & UIPanGestureRecognizerDirectionUp) || (direction & UIPanGestureRecognizerDirectionDown))
            return NO;
        else return YES;
    }
    else return NO;
}

#pragma mark - Handle Pan Gestures
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer
{
    switch (panGestureRecognizer.state)
    {
        case UIGestureRecognizerStatePossible:
        {
            [self handleGestureRecongizerPossibleState:panGestureRecognizer];
        }
        case UIGestureRecognizerStateBegan:
        {
            [self handleGestureRecongizerBeganState:panGestureRecognizer];
        }
        case UIGestureRecognizerStateChanged:
        {
            [self handleGestureRecongizerChangedState:panGestureRecognizer];
        }
        case UIGestureRecognizerStateEnded:
        {
            [self handleGestureRecongizerEndedState:panGestureRecognizer];
        }
        case UIGestureRecognizerStateCancelled:
        {
            [self handleGestureRecongizerCancelledState:panGestureRecognizer];
        }
        case UIGestureRecognizerStateFailed:
        {
            [self handleGestureRecongizerFailedState:panGestureRecognizer];
        }
        default:
            break;
    }
}

- (void)handleGestureRecongizerPossibleState:(UIPanGestureRecognizer *)panGestureRecognizer
{

}

- (void)handleGestureRecongizerBeganState:(UIPanGestureRecognizer *)panGestureRecognizer
{
 
}

- (void)handleGestureRecongizerChangedState:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIPanGestureRecognizerDirection gestureDirection = [panGestureRecognizer panGestureDirectionInView:self.cellContentView];
    if (gestureDirection & UIPanGestureRecognizerDirectionLeft
        || gestureDirection & UIPanGestureRecognizerDirectionRight)
    {
        CGPoint translation = [panGestureRecognizer translationInView:[self.cellContentView superview]];
        if ([self isProposedCellContentViewTranslationPermitted:translation])
            [self.cellContentView setCenter:CGPointMake([self.cellContentView center].x + translation.x, [self.cellContentView center].y)];
        [panGestureRecognizer setTranslation:CGPointZero inView:self.cellContentView];
    }
    
}

- (BOOL)isProposedCellContentViewTranslationPermitted:(CGPoint)translation
{
    if (translation.x > 0)
    {
        CGRect locationInSuperView = [self.cellContentView.superview convertRect:self.cellContentView.frame toView:self.cellContentView.superview];
        locationInSuperView.origin.x += translation.x;
        if (locationInSuperView.origin.x < 0)
            return YES;
        
        locationInSuperView.origin.y += translation.y;
        return CGRectContainsRect(self.frame, locationInSuperView);
    }
    else
        return YES;
}

- (void)handleGestureRecongizerEndedState:(UIPanGestureRecognizer *)panGestureRecognizer
{

}

- (void)handleGestureRecongizerCancelledState:(UIPanGestureRecognizer *)panGestureRecognizer
{

}

- (void)handleGestureRecongizerFailedState:(UIPanGestureRecognizer *)panGestureRecognizer
{

}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self styleCell];
    [self setupPanGestureRecognizer];
}

- (void)setupPanGestureRecognizer
{
    if (!_panGestureRecognizer)
    {
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        self.panGestureRecognizer.maximumNumberOfTouches = 1;
        self.panGestureRecognizer.minimumNumberOfTouches = 1;
        self.panGestureRecognizer.delegate = self;
        [self.cellContentView addGestureRecognizer:self.panGestureRecognizer];
    }
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