//
//  NSLayoutConstraint+Utility.h
//  Hakken
//
//  Created by Sidd Sathyam on 4/4/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

@import UIKit;

@interface NSLayoutConstraint (Utility)

+ (instancetype)constraintToContainerForView:(UIView *)view attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant;
+ (instancetype)constraintFromView:(UIView *)view toView:(UIView *)otherView attribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant;
+ (instancetype)constraintForView:(UIView *)view unaryAttribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant;

+ (NSArray *)constraintsToContainerForView:(UIView *)view insets:(UIEdgeInsets)insets;
+ (NSArray *)constraintsToContainerForView:(UIView *)view insets:(UIEdgeInsets)insets edges:(UIRectEdge)edges;
+ (NSArray *)constraintsForView:(UIView *)view size:(CGSize)size;
+ (NSArray *)constraintsForEqualSizesFromView:(UIView *)view toView:(UIView *)otherView;

@end
