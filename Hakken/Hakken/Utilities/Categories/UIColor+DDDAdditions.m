//
//  UIColor+DDDAdditions.m
//  Hakken
//
//  Created by Sidd Sathyam on 12/26/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "UIColor+DDDAdditions.h"

@implementation UIColor (DDDAdditions)
+ (UIColor *)swipeActionViewGrayColor
{
    return [UIColor colorWithRed:1.f/3.f green:1.f/3.f blue:1.f/3.f alpha:1.f];
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
