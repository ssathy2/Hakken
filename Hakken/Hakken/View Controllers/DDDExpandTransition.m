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
    return 0.7;
}

- (UIView *)topHalfViewSnapshotFromView:(UIView *)fromView
{
    CGRect topHalfOfViewRect = CGRectMake(0, 0, fromView.frame.size.width, fromView.frame.size.height/2);
    return [fromView resizableSnapshotViewFromRect:topHalfOfViewRect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
}

- (UIView *)bottomHalfViewSnapshotFromView:(UIView *)fromView
{
    CGRect bottomHalfOfViewRect = CGRectMake(0, fromView.frame.size.height/2, fromView.frame.size.width, fromView.frame.size.height/2);
    return [fromView resizableSnapshotViewFromRect:bottomHalfOfViewRect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    DDDViewController *fromViewController = (DDDViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    DDDViewController *toViewController = (DDDViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromViewController.view;
    UIView *toView   = toViewController.view;
    
    UIView *containerView = [transitionContext containerView];
    
    // Get snapshots to the top and bottom of the fromView
    UIView *fromViewTopHalf = [self topHalfViewSnapshotFromView:fromView];
    UIView *fromViewBottomHalf = [self bottomHalfViewSnapshotFromView:fromView];
    fromViewTopHalf.frame = CGRectMake(0, 0, fromViewTopHalf.frame.size.width, fromViewTopHalf.frame.size.height);
    fromViewBottomHalf.frame = CGRectMake(0, fromViewTopHalf.frame.size.height, fromViewBottomHalf.frame.size.width, fromViewBottomHalf.frame.size.height);
    
    toView.alpha = 0.f;
    toView.frame = [transitionContext finalFrameForViewController:toViewController];
    
    [containerView addSubview:fromViewTopHalf];
    [containerView addSubview:fromViewBottomHalf];
    [containerView addSubview:toView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toView.alpha = 1.f;

        // animate the top snapshot going up and the bottom snapshot going down
        CGRect fromViewTopHalfFrame = fromViewTopHalf.frame;
        fromViewTopHalfFrame.origin = CGPointMake(0, -1000);
        fromViewTopHalf.frame = fromViewTopHalfFrame;
        
        CGRect fromViewBottomHalfFrame = fromViewBottomHalf.frame;
        fromViewBottomHalfFrame.origin = CGPointMake(0, 1000);
        fromViewBottomHalf.frame = fromViewBottomHalfFrame;
        
    } completion:^(BOOL finished) {
        // Clean up
        // Declare that we've finished
        [fromViewBottomHalf removeFromSuperview];
        [fromViewTopHalf removeFromSuperview];
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}
@end
