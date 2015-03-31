//
//  DDDRightNavigationView.m
//  Hakken
//
//  Created by sathyam on 3/31/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "DDDRightNavigationView.h"

@interface DDDRightNavigationView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UITapGestureRecognizer *gestureRecognizer;
@end

@implementation DDDRightNavigationView
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.numberLabel applyRoundedCornersWithRadius:CGRectGetHeight(self.numberLabel.bounds)/2 width:CGRectGetWidth(self.numberLabel.bounds)/2 color:[UIColor redColor]];
    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
}

- (void)viewTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)setNumber:(NSInteger)number animated:(BOOL)animated withCustomAnimations:(ViewAnimationBlock)animationBlock
{
    void(^setNumberBlock)() = ^() {
        self.numberLabel.text = [NSString stringWithFormat:@"%li", number];
    };
    
    if (animated)
    {
        if (animationBlock)
        {
            [UIView animateWithDuration:0.2 animations:^{
                setNumberBlock();
                animationBlock(self);
            }];
        }
        else
        {
            [UIView animateWithDuration:0.2 delay:0.f usingSpringWithDamping:0.3 initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                setNumberBlock();
            } completion:nil];
        }
    }
    else
        setNumberBlock();
    
    [self.numberLabel sizeToFit];
}

- (void)setNumberViewHidden:(BOOL)hidden animated:(BOOL)animated
{
    void(^hideBlock)(BOOL) = ^(BOOL hidden) {
        self.numberLabel.hidden = hidden;
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.2 animations:^{
            hideBlock(hidden);
        }];
    }
    else
        hideBlock(hidden);
}
@end
