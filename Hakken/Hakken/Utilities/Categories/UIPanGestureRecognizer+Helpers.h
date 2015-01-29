//
//  UIPanGestureRecognizer+Helpers.h
//  Hakken
//
//  Created by Sidd Sathyam on 1/28/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, UIPanGestureRecognizerDirection)
{
    UIPanGestureRecognizerDirectionNone         = 0,
    UIPanGestureRecognizerDirectionLeft         = 1 << 0,
    UIPanGestureRecognizerDirectionRight        = 1 << 1,
    UIPanGestureRecognizerDirectionUp           = 1 << 2,
    UIPanGestureRecognizerDirectionDown         = 1 << 3
};

@interface UIPanGestureRecognizer (Helpers)
- (UIPanGestureRecognizerDirection)panGestureDirectionInView:(UIView *)view;
@end
