//
//  UINavigationBar+Styling.m
//  Hakken
//
//  Created by Sidd Sathyam on 4/18/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "UINavigationBar+Styling.h"

@implementation UINavigationBar (Styling)
+ (void)applyGlobalNavigationBarStyles
{
    [[self appearance] setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName: [UIColor whiteColor],
                                                NSFontAttributeName           : [UIFont fontWithName:@"AvenirNext-DemiBold" size:18.f],
                                                }];
    [[self appearance] setTintColor:[UIColor whiteColor]];
}
@end
