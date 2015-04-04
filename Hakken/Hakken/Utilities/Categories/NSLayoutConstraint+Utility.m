//
//  NSLayoutConstraint+Utility.h
//  Hakken
//
//  Created by Sidd Sathyam on 4/4/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "NSLayoutConstraint+Utility.h"

@implementation NSLayoutConstraint (Utility)

+ (instancetype)constraintToContainerForView:(UIView *)view attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant
{
    NSLayoutAttribute relatedAttribute = DDDParentAttributeForAttribute(attribute);
    return [self constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:relatedAttribute multiplier:1.0f constant:constant];
}

+ (instancetype)constraintFromView:(UIView *)view toView:(UIView *)otherView attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant
{
    NSLayoutAttribute relatedAttribute = DDDSiblingAttributeForAttribute(attribute);
    return [self constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:otherView attribute:relatedAttribute multiplier:1.0f constant:constant];
}

+ (instancetype)constraintForView:(UIView *)view unaryAttribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant;
{
    return [NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:constant];
}

+ (NSArray *)constraintsToContainerForView:(UIView *)view insets:(UIEdgeInsets)insets
{
    return [self constraintsToContainerForView:view insets:insets edges:UIRectEdgeAll];
}

+ (NSArray *)constraintsToContainerForView:(UIView *)view insets:(UIEdgeInsets)insets edges:(UIRectEdge)edges
{
    NSMutableArray *constraints = [NSMutableArray arrayWithCapacity:4];
    
    if(edges & UIRectEdgeTop)
        [constraints addObject:[self constraintToContainerForView:view attribute:NSLayoutAttributeTop constant:insets.top]];
    if(edges & UIRectEdgeLeft)
        [constraints addObject:[self constraintToContainerForView:view attribute:NSLayoutAttributeLeading constant:insets.left]];
    if(edges & UIRectEdgeBottom)
        [constraints addObject:[self constraintToContainerForView:view attribute:NSLayoutAttributeBottom constant:-insets.bottom]];
    if(edges & UIRectEdgeRight)
        [constraints addObject:[self constraintToContainerForView:view attribute:NSLayoutAttributeTrailing constant:-insets.right]];

    return constraints;
}

+ (NSArray *)constraintsForView:(UIView *)view size:(CGSize)size
{
    return @[
        [NSLayoutConstraint constraintForView:view unaryAttribute:NSLayoutAttributeWidth constant:size.width],
        [NSLayoutConstraint constraintForView:view unaryAttribute:NSLayoutAttributeHeight constant:size.height],
    ];
}

+ (NSArray *)constraintsForEqualSizesFromView:(UIView *)view toView:(UIView *)otherView
{
    return @[
        [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f],
        [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f],
    ];
}

NS_INLINE NSLayoutAttribute DDDParentAttributeForAttribute(NSLayoutAttribute attribute)
{
    switch(attribute)
    {
        case NSLayoutAttributeLeading:
            return NSLayoutAttributeLeft;
        case NSLayoutAttributeTrailing:
            return NSLayoutAttributeRight;
        default:
            return attribute;
    }
}

NS_INLINE NSLayoutAttribute DDDSiblingAttributeForAttribute(NSLayoutAttribute attribute)
{
    switch (attribute)
    {
        case NSLayoutAttributeTrailing:
            return NSLayoutAttributeLeft;
        case NSLayoutAttributeLeading:
            return NSLayoutAttributeRight;
        default:
            return attribute;
    }
}

@end
