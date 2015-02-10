//
//  UIColor+DDDAdditions.m
//  Hakken
//
//  Created by Sidd Sathyam on 12/26/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "UIColor+DDDAdditions.h"

@implementation UIColor (DDDAdditions)
+ (UIColor *)colorForDepth:(NSInteger)depth
{
    switch (depth) {
        case 0:
            return [UIColor clearColor];
        case 1:
            return [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
        case 2:
            return [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        case 3:
            return [UIColor colorWithRed:1 green:1 blue:0 alpha:1];
        case 4:
            return [UIColor colorWithRed:0 green:1 blue:1 alpha:1];
        case 5:
            return [UIColor colorWithRed:1 green:1 blue:0 alpha:1];
        default:
            return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
}

+ (UIColor *)swipeActionViewRedColor
{
    return [UIColor colorWithRed:170.f/255.f green:0.f blue:5.f/255.f alpha:1.f];
}

+ (UIColor *)swipeActionViewGreenColor
{
    return [UIColor colorWithRed:5.f/255.f green:170.f/255.f blue:0.f alpha:1.f];
}
@end
