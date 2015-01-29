//
//  UIPanGestureRecognizer+Helpers.m
//  Hakken
//
//  Created by Sidd Sathyam on 1/28/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "UIPanGestureRecognizer+Helpers.h"

@implementation UIPanGestureRecognizer (Helpers)
- (UIPanGestureRecognizerDirection)panGestureDirectionInView:(UIView *)view;
{
    CGPoint velocityInView = [self velocityInView:view];
    UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionNone;
    if (velocityInView.x > 0)
        direction |= UIPanGestureRecognizerDirectionRight;
    else
        direction |= UIPanGestureRecognizerDirectionLeft;
    
    if (velocityInView.y > 0)
        direction |= UIPanGestureRecognizerDirectionUp;
    else
        direction |= UIPanGestureRecognizerDirectionDown;

    return direction;
}
@end
