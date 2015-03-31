//
//  DDDRightNavigationView.h
//  Hakken
//
//  Created by sathyam on 3/31/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Utility.h"

@class DDDRightNavigationView;

typedef void(^ViewAnimationBlock)(DDDRightNavigationView *navigationView);

@interface DDDRightNavigationView : UIControl
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

// sets the number of the navigation view with any custom animations. If the 'animated' param is YES but 'animationBlock' is nil then a default spring animation will be used.
- (void)setNumber:(NSInteger)number animated:(BOOL)animated withCustomAnimations:(ViewAnimationBlock)animationBlock;

- (void)setNumberViewHidden:(BOOL)hidden animated:(BOOL)animated;
@end
