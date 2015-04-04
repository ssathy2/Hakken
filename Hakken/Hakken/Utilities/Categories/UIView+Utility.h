//
//  UIView+Utility.h
//  Hakken
//
//  Created by sathyam on 3/31/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utility)
+ (instancetype)instance;

- (void)applyRoundedCornersWithRadius:(CGFloat)radius;
- (void)addSubviewWithConstraints:(UIView *)subview;
@end
