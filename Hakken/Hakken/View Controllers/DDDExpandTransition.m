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
    return 0.99f;
}

- (UIView *)topPartOfView:(UIView *)fromView withCellRect:(CGRect)cellRect
{
    CGRect topHalfOfViewRect = (CGRect){fromView.frame.origin, CGSizeMake(fromView.frame.size.width, cellRect.size.height - fromView.frame.origin.y)};
    return [fromView resizableSnapshotViewFromRect:topHalfOfViewRect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
}

- (UIView *)bottomPartOfView:(UIView *)fromView withCellRect:(CGRect)cellRect
{
    CGRect bottomHalfOfViewRect = (CGRect){CGPointMake(cellRect.origin.x, cellRect.origin.y+cellRect.size.height), CGSizeMake(fromView.frame.size.width, fromView.frame.size.height-cellRect.origin.y+cellRect.size.height)};
    return [fromView resizableSnapshotViewFromRect:bottomHalfOfViewRect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    DDDViewController *fromViewController = (DDDViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    DDDViewController *toViewController = (DDDViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromViewController.view;
    UIView *toView   = toViewController.view;
    
    UIView *containerView = [transitionContext containerView];
    [containerView setBackgroundColor:[UIColor darkGrayColor]];
    
    CGRect cellRect = [self originRectFromContext:transitionContext];
    UIView *topFromView = [fromView resizableSnapshotViewFromRect:cellRect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    UIView *bottomFromView = [self bottomPartOfView:fromView withCellRect:cellRect];
    
    [toView setAlpha:0.0f];
    [containerView addSubview:toView];

    [containerView addSubview:topFromView];
    [containerView addSubview:bottomFromView];
    
    [topFromView setFrame:cellRect];
    [bottomFromView setFrame:(CGRect){CGPointMake(cellRect.origin.x, cellRect.origin.y+cellRect.size.height), bottomFromView.frame.size}];
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext]  delay:0.0f options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.33f animations:^{
            [fromView setAlpha:0.0f];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.33f relativeDuration:0.33f animations:^{
            [bottomFromView setFrame:(CGRect){CGPointMake(0, 1000), bottomFromView.frame.size}];
            [bottomFromView setAlpha:0.f];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.66f relativeDuration:0.33f animations:^{
            [topFromView setFrame:(CGRect){fromView.frame.origin, topFromView.frame.size}];
        }];
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
        
        [toView setAlpha:1.0f];
        [fromView removeFromSuperview];
        [containerView addSubview:toView];
        [topFromView removeFromSuperview];
        [bottomFromView removeFromSuperview];
    }];
}

- (CGRect)originRectFromContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if ([fromViewController respondsToSelector:@selector(collectionView)])
    {
        UICollectionView *collectionView = [fromViewController performSelector:@selector(collectionView)];
        NSIndexPath *indexPath = [[collectionView indexPathsForSelectedItems] firstObject];
        UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
        return [collectionView convertRect:attributes.frame toView:fromViewController.view];
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
