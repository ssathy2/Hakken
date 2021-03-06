//
//  UIColor+DDDAdditions.h
//  Hakken
//
//  Created by Sidd Sathyam on 12/26/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DDDAdditions)
+ (UIColor *)swipeActionViewRedColor;
+ (UIColor *)swipeActionViewGreenColor;
+ (UIColor *)swipeActionViewGrayColor;

+ (UIColor *)navigationBarBackgroundColor;
+ (UIColor *)colorForDepth:(NSInteger)depth;
@end
