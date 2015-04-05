//
//  DDDHackerNewsItemCollectionViewCell.m
//  Hakken
//
//  Created by Sidd Sathyam on 12/1/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDHackerNewsItemCollectionViewCell.h"
#import "DDDHackerNewsItem.h"
#import "DDDHakkenReadLaterInformation.h"

typedef NS_ENUM(NSInteger, DDDCellSwipeState)
{
    DDDCellSwipeStateUnselected,
    DDDCellSwipeStateSelected
};

@interface DDDHackerNewsItemCollectionViewCell()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (weak, nonatomic) IBOutlet UILabel *pointDatePostedLabel;
@property (weak, nonatomic) IBOutlet UIView *confirmationView;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *cellContentView;
@property (weak, nonatomic) IBOutlet UIView *swipeActionView;
@property (weak, nonatomic) IBOutlet UILabel *swipeActionViewLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *swipeActionViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellContentViewLeadingSpacingConstraint;

@property (weak, nonatomic) IBOutlet UIView *unreadIndicatorView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (readonly, nonatomic) DDDCellSwipeState cellSwipeState;
@end

@implementation DDDHackerNewsItemCollectionViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.commentsButton.hidden = self.urlLabel.hidden = NO;
    self.swipeActionViewWidthConstraint.constant = 0.f;
    self.cellContentViewLeadingSpacingConstraint.constant = 0.f;
    self.confirmationView.hidden = YES;
    [self resetCellContentView:NO shouldShowConfirmationView:NO];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self resetCellContentView:NO shouldShowConfirmationView:NO];
    [self styleCell];
}

- (void)styleCell
{
    self.commentsButton.layer.masksToBounds = NO;
    [self.commentsButton.layer setCornerRadius:self.commentsButton.frame.size.height/2];
    [self.unreadIndicatorView applyRoundedCornersWithRadius:CGRectGetHeight(self.unreadIndicatorView.bounds)];
    self.swipeActionView.clipsToBounds = YES;
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
            break;
        }
        case UIGestureRecognizerStateBegan:
        {
            [self handleGestureRecongizerBeganState:panGestureRecognizer];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self handleGestureRecongizerChangedState:panGestureRecognizer];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self handleGestureRecongizerEndedState:panGestureRecognizer];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        {
            [self handleGestureRecongizerCancelledState:panGestureRecognizer];
            break;
        }
        case UIGestureRecognizerStateFailed:
        {
            [self handleGestureRecongizerFailedState:panGestureRecognizer];
            break;
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

- (void)handleGestureRecongizerCancelledState:(UIPanGestureRecognizer *)panGestureRecognizer
{
    [self resetCellContentView:YES shouldShowConfirmationView:NO];
    [self notifyDelegateAboutCellSwipeState];

}

- (void)handleGestureRecongizerFailedState:(UIPanGestureRecognizer *)panGestureRecognizer
{
    [self resetCellContentView:YES shouldShowConfirmationView:NO];
    [self notifyDelegateAboutCellSwipeState];
}

- (void)handleGestureRecongizerChangedState:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIPanGestureRecognizerDirection gestureDirection = [panGestureRecognizer panGestureDirectionInView:self.cellContentView];
    if (gestureDirection & UIPanGestureRecognizerDirectionLeft
        || gestureDirection & UIPanGestureRecognizerDirectionRight)
    {
        CGPoint translation = [panGestureRecognizer translationInView:[self.cellContentView superview]];
        if ([self isProposedCellContentViewTranslationPermitted:translation])
        {
            self.cellContentViewLeadingSpacingConstraint.constant -= translation.x;
            // Figure out how much the cell has moved by in the X direction sand set the width constraint to that difference
            self.swipeActionViewWidthConstraint.constant -= translation.x;
            
            [self setSwipeActionViewColors:YES];
        }
        [panGestureRecognizer setTranslation:CGPointZero inView:self.contentView];
    }
}

- (void)handleGestureRecongizerEndedState:(UIPanGestureRecognizer *)panGestureRecognizer
{
    [self resetCellContentView:YES shouldShowConfirmationView:(self.cellSwipeState == DDDCellSwipeStateSelected)];
    [self notifyDelegateAboutCellSwipeState];
}

- (void)closeCellSwipeContainer
{
    [self resetCellContentView:YES shouldShowConfirmationView:NO];
    [self notifyDelegateAboutCellSwipeState];
}

- (void)notifyDelegateAboutCellSwipeState
{
    DDDHackerNewsItem *hackernewsItem = (DDDHackerNewsItem *)self.model;
    if (self.cellSwipeState == DDDCellSwipeStateSelected)
    {
        if (hackernewsItem.readLaterInformation.userWantsToReadLater)
        {
            if ([self.delegate respondsToSelector:@selector(cell:didSelectRemoveFromReadLater:withCompletion:withError:)])
            {
                [self.delegate cell:self didSelectRemoveFromReadLater:hackernewsItem withCompletion:^(DDDHackerNewsItem *item) {
                    [self prepareWithModel:hackernewsItem];
                } withError:^(NSError *error) {
                    // TODO: handle error here
                }];
            }
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(cell:didSelectAddToReadLater:withCompletion:withError:)])
            {
                [self.delegate cell:self didSelectAddToReadLater:hackernewsItem withCompletion:^(DDDHackerNewsItem *item) {
                    [self prepareWithModel:hackernewsItem];
                } withError:^(NSError *error) {
                    // TODO: Handle error here...
                }];
                
            }
        }
    }
}

- (void)setSwipeActionViewColors:(BOOL)animated
{
    void(^setBGColorBlock)() = ^() {
        if (self.cellSwipeState == DDDCellSwipeStateSelected)
        {
            self.swipeActionView.backgroundColor = [UIColor swipeActionViewGreenColor];
            self.swipeActionViewLabel.textColor = [UIColor whiteColor];
        }
        else
        {
            self.swipeActionView.backgroundColor = [UIColor swipeActionViewGrayColor];
            self.swipeActionViewLabel.textColor = [UIColor whiteColor];
        }
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.1 animations:setBGColorBlock];
    }
    else
        setBGColorBlock();
}

- (BOOL)isProposedCellContentViewTranslationPermitted:(CGPoint)translation
{
    CGRect locationInSuperView = [self.cellContentView.superview convertRect:self.cellContentView.frame toView:self.cellContentView.superview];
    locationInSuperView.origin.x += translation.x;
    locationInSuperView.origin.y += translation.y;
    
    return CGRectIntersectsRect(self.contentView.frame, locationInSuperView) && (self.swipeActionViewWidthConstraint.constant - translation.x >= 0);
}

- (void)resetCellContentView:(BOOL)animated shouldShowConfirmationView:(BOOL)shouldShowConfirmationView
{
    void(^cellContentViewReset)() = ^() {
        CGRect cellContentFrame = self.cellContentView.frame;
        cellContentFrame.origin = CGPointZero;
        CGRect swipeActionView = CGRectMake(cellContentFrame.origin.x + cellContentFrame.size.width, 0.f, 0.f, cellContentFrame.size.height);
        self.cellContentView.frame = cellContentFrame;
        self.swipeActionView.frame = swipeActionView;
    };
    
    void(^cellContentViewResetCompletion)() = ^() {
        self.swipeActionViewWidthConstraint.constant = 0.f;
        self.swipeActionView.backgroundColor = [UIColor swipeActionViewGrayColor];
        [self updateConstraintsIfNeeded];
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.55f
                              delay:0.f
             usingSpringWithDamping:0.5f
              initialSpringVelocity:0.1
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                cellContentViewReset();
                            } completion:^(BOOL finished) {
                                cellContentViewResetCompletion();
                            }];
    }
    else
    {
        cellContentViewReset();
        cellContentViewResetCompletion();
    }
}

- (IBAction)didTouchDownOnCommentButton:(UIButton *)sender
{
    [UIView animateWithDuration:0.2
                          delay:0.f
         usingSpringWithDamping:0.4f
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            self.commentsButton.transform = CGAffineTransformMakeScale(0.75, 0.75);
                        } completion:nil];
}

- (IBAction)resetButtonTransform:(id)sender
{
    [UIView animateWithDuration:0.2
                          delay:0.f
         usingSpringWithDamping:0.4f
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            self.commentsButton.transform = CGAffineTransformMakeScale(1.f, 1.f);
                        } completion:nil];
}

- (IBAction)didTouchUpOnCommentButton:(UIButton *)sender
{
    [UIView animateWithDuration:0.2
                          delay:0.f
         usingSpringWithDamping:0.4f
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

- (void)prepareWithModel:(DDDHackerNewsItem *)model
{
    [super prepareWithModel:model];
    self.userName.text = [NSString stringWithFormat:@"from %@", model.by];
    
    self.pointDatePostedLabel.text = [NSString stringWithFormat:@"%@ %@ - %@", @(model.score), (model.score > 1) ? @"points" : @"point", [[model dateCreated] relativeDateTimeStringToNow]];
    self.titleLabel.text = model.title;
    
    [self styleURLLabelWithHackernewsItem:model];
    
    [self.commentsButton setTitle:[@(model.descendants) stringValue] forState:UIControlStateNormal];
    
    self.swipeActionViewLabel.text = (model.readLaterInformation.userWantsToReadLater) ? @"Remove from read later" : @"Add to read later";
}

- (void)styleURLLabelWithHackernewsItem:(DDDHackerNewsItem *)item
{
    if (item.isUserGenerated)
        self.urlLabel.hidden = YES;
    
    if (item.itemType == DDDHackerNewsItemTypeJob)
        self.commentsButton.hidden = YES;
    
    self.urlLabel.text = [NSString stringWithFormat:@"(%@)", [item.itemURL host]];
}

#pragma mark - Custom Getters
- (DDDCellSwipeState)cellSwipeState
{
    CGFloat percentageSwiped = self.swipeActionViewWidthConstraint.constant / CGRectGetWidth(self.contentView.bounds);
    if (percentageSwiped > 0.3)
        return DDDCellSwipeStateSelected;
    else
        return DDDCellSwipeStateUnselected;
}
@end