//
//  DDDTopStoriesPushAnimator.m
//  Hakken
//
//  Created by Sidd Sathyam on 12/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDTopStoriesPushAnimator.h"
#import "DDDTopStoriesViewController.h"
#import "DDDStoryDetailViewController.h"

@implementation DDDTopStoriesPushAnimator
- (CGFloat)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    DDDTopStoriesViewController* topStoriesVC   = (DDDTopStoriesViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    DDDStoryDetailViewController* storyDetailVC = (DDDStoryDetailViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *topStoriesView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *storyDetailView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    [[transitionContext containerView] addSubview:storyDetailView];
    storyDetailView.alpha = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        topStoriesView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        storyDetailView.alpha = 1;
    } completion:^(BOOL finished) {
        topStoriesView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}
@end
