//
//  UIView+Instantiation.m
//  Hakken
//
//  Created by Sidd Sathyam on 2/13/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

#import "UIView+Instantiation.h"

@implementation UIView (Instantiation)
+ (UINib *)ddd_nibNamed:(NSString *)nibName
{
    return [UINib nibWithNibName:nibName bundle:nil];
}

+ (UINib *)ddd_nib
{
    return [self ddd_nibNamed:NSStringFromClass([self class])];
}

+ (instancetype)ddd_loadInstanceWithNib:(UINib *)nib
{
    UIView *result = nil;
    NSArray *topLevelObjects = [nib instantiateWithOwner:nil options:nil];
    for (id anObject in topLevelObjects)
    {
        if ([anObject isKindOfClass:[self class]])
        {
            result = anObject;
            break;
        }
    }
    
    return result;
}

+ (instancetype)ddd_loadInstanceFromNib
{
    return [self ddd_loadInstanceWithNib:[self ddd_nib]];
}
@end
