//
//  UIView+Instantiation.h
//  Hakken
//
//  Created by Sidd Sathyam on 2/13/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Instantiation)
+ (UINib *)ddd_nibNamed:(NSString *)nibName;
+ (UINib *)ddd_nib;
+ (instancetype)ddd_loadInstanceWithNib:(UINib *)nib;
+ (instancetype)ddd_loadInstanceFromNib;
@end
