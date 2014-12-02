//
//  DDDExpandTransition.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/29/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDExpandTransition.h"
#import "DDDViewController.h"

@implementation DDDExpandTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 2.f;
}

- (UIView *)topPartOfView:(UIView *)fromView withYPosition:(CGFloat)yPosition
{
    CGRect topHalfOfViewRect = CGRectMake(0, 0, fromView.frame.size.width, yPosition);
    return [fromView resizableSnapshotViewFromRect:topHalfOfViewRect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
}

- (UIView *)bottomPartOfView:(UIView *)fromView withYPosition:(CGFloat)yPosition
{
    CGRect bottomHalfOfViewRect = CGRectMake(0, yPosition, fromView.frame.size.width, fromView.frame.size.height-yPosition);
    return [fromView resizableSnapshotViewFromRect:bottomHalfOfViewRect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    DDDViewController *fromViewController = (DDDViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    DDDViewController *toViewController = (DDDViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromViewController.view;
    UIView *toView   = toViewController.view;
    
    UICollectionView *fromCollectionView = [(UICollectionViewController *)fromViewController collectionView];
    
    UIView *containerView = [transitionContext containerView];
    [containerView setBackgroundColor:[UIColor darkGrayColor]];
    
    [toView setAlpha:0.0f];
    [containerView addSubview:toView];
    
    CGRect originRect = [self originRectFromContext:transitionContext];
    CGRect destinationRect = [self destinationRectFromContext:transitionContext];
    
    CGRect firstRect = CGRectMake(destinationRect.origin.x, destinationRect.origin.y, destinationRect.size.width, originRect.size.height);
    
    UIView *snapshot = [fromCollectionView resizableSnapshotViewFromRect:originRect afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    snapshot.transform = CGAffineTransformMakeScale(0, 0);
    
    [snapshot setFrame:[containerView convertRect:originRect fromView:fromCollectionView]];
    [containerView addSubview:snapshot];
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext]  delay:0.0f options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.33f animations:^{
            [fromView setAlpha:0.0f];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.33f relativeDuration:0.33f animations:^{
            [snapshot setFrame:firstRect];
        }];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
        
        [toView setAlpha:1.0f];
        [fromView removeFromSuperview];
        [containerView addSubview:toView];
        [snapshot removeFromSuperview];
    }];
}

- (CGRect)originRectFromContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if ([fromViewController respondsToSelector:@selector(collectionView)])
    {
        UICollectionView *collectionView = [fromViewController performSelector:@selector(collectionView)];
        NSIndexPath *indexPath = [[collectionView indexPathsForSelectedItems] firstObject];
        UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
        return attributes.frame;
    }
    return CGRectZero;
}

- (CGRect)destinationRectFromContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if ([toViewController respondsToSelector:@selector(collectionView)])
    {
//        UICollectionView *collectionView = [toViewController performSelector:@selector(collectionView)];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        // Can't get the destination rect properly from teh collection view's flow becuase the collectionview is still nil at this point
        // Hardcode this for now
        UIView *toView = toViewController.view;
        return toView.frame;
//        UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
//        return attributes.frame;
//        return frame;
    }
    return CGRectZero;
}
@end
