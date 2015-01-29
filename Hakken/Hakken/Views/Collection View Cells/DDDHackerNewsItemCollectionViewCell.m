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

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *cellContentView;
@property (weak, nonatomic) IBOutlet UIView *swipeActionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellContentTrailingSpaceConstraint;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@property (assign, nonatomic) CGPoint lastRecordedRecognizerLocationPoint;
@end

@implementation DDDHackerNewsItemCollectionViewCell

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
    UIPanGestureRecognizerDirection gestureDirection = [panGestureRecognizer panGestureDirectionInView:self.cellContentView];
    if (gestureDirection & UIPanGestureRecognizerDirectionLeft)
        self.lastRecordedRecognizerLocationPoint = [panGestureRecognizer locationInView:self.cellContentView];
}

- (void)handleGestureRecongizerChangedState:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIPanGestureRecognizerDirection gestureDirection = [panGestureRecognizer panGestureDirectionInView:self.cellContentView];
    if (gestureDirection & UIPanGestureRecognizerDirectionLeft)
    {
        DDLogDebug(@"panGestureRecognizerDirectionLeft");
        CGPoint currentLocationInView = [panGestureRecognizer locationInView:self.cellContentView];
        CGFloat constantAmount = abs(currentLocationInView.x - self.lastRecordedRecognizerLocationPoint.x);
        if (constantAmount > 0)
            self.cellContentTrailingSpaceConstraint.constant += constantAmount;
    }
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
                            self.commentsButton.transform = CGAffineTransformMakeScale(0.90, 0.90);
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
    
    self.urlLabel.text = [NSString stringWithFormat:@"(%@)", [hnItem.itemURL host]];
    
    self.pointDatePostedLabel.text = [NSString stringWithFormat:@"%@ %@ - %@", @(hnItem.score), (hnItem.score > 1) ? @"points" : @"point", [[hnItem dateCreated] relativeDateTimeStringToNow]];
    self.titleLabel.text = hnItem.title;
    
    // TODO: Get the actual number of comments
    [self.commentsButton setTitle:[@(hnItem.kids.count) stringValue] forState:UIControlStateNormal];
}
@end