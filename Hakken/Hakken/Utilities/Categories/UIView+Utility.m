//
//  UIView+Utility.m
//  Hakken
//
//  Created by sathyam on 3/31/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "UIView+Utility.h"

@implementation UIView (Utility)
+ (instancetype)instance
{
    return [[[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
}

- (void)applyRoundedCornersWithRadius:(CGFloat)radius width:(CGFloat)width color:(UIColor *)color
{
    self.clipsToBounds      = YES;
    self.layer.cornerRadius = radius;
    self.layer.borderWidth  = width;
    
    if (color)
        self.layer.borderColor = color.CGColor;
}
@end
