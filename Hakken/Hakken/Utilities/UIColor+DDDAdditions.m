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
           return [UIColor colorWithRed:0 green:255 blue:0 alpha:1];
        case 2:
           return [UIColor colorWithRed:0 green:0 blue:255 alpha:1];
        case 3:
           return [UIColor colorWithRed:255 green:255 blue:0 alpha:1];
        case 4:
           return [UIColor colorWithRed:0 green:255 blue:255 alpha:1];
        default:
            return [UIColor colorWithRed:255 green:255 blue:255 alpha:1];
    }
}
@end
