//
//  UIView+Utility.m
//  Hakken
//
//  Created by sathyam on 3/31/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "UIView+Utility.h"
#import "NSLayoutConstraint+Utility.h"

@implementation UIView (Utility)
+ (instancetype)instance
{
    return [[[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
}

- (void)applyRoundedCornersWithRadius:(CGFloat)radius
{
    self.clipsToBounds          = YES;
    self.layer.masksToBounds    = YES;
    self.layer.cornerRadius     = radius;
}

- (void)addSubviewWithConstraints:(UIView *)subview
{
    [self addSubview:subview];
    [self addConstraints:[NSLayoutConstraint constraintsToContainerForView:subview insets:UIEdgeInsetsZero]];
    [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
}
@end
