//
//  UIView+Autolayout.m
//  Hakken
//
//  Created by Sidd Sathyam on 2/13/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

#import "UIView+Autolayout.h"

@implementation UIView (Autolayout)
- (NSArray *)ddd_migrateConstraintsToView:(UIView *)view
{
    return [self ddd_migrateConstraints:self.constraints toView:view];
}

- (NSArray *)ddd_migrateConstraints:(NSArray *)constraints toView:(UIView *)view
{
    return (constraints ?: @[]).map(^(NSLayoutConstraint *constraint) {
        return [self ddd_migrateConstraint:constraint toView:view];
    });
}

#pragma mark - Helpers

- (NSLayoutConstraint *)ddd_migrateConstraint:(NSLayoutConstraint *)constraint toView:(UIView *)view;
{
    NSLayoutAttribute firstAttribute  = constraint.firstAttribute;
    NSLayoutAttribute secondAttribute = constraint.secondAttribute;
    
    id firstItem  = [self ddd_migrateItem:constraint.firstItem attribute:&firstAttribute toView:view];
    id secondItem = [self ddd_migrateItem:constraint.secondItem attribute:&secondAttribute toView:view];
    
    // autolayout is so beautiful
    return [NSLayoutConstraint constraintWithItem:firstItem attribute:firstAttribute relatedBy:constraint.relation
                                           toItem:secondItem attribute:secondAttribute
                                       multiplier:constraint.multiplier constant:constraint.constant];
}

- (id)ddd_migrateItem:(id)item attribute:(NSLayoutAttribute *)attribute toView:(UIView *)view
{
    id result = item;
    
    // if the item is us, migrate to the view
    if(item == self) {
        result = view;
    }
    else if([item conformsToProtocol:@protocol(UILayoutSupport)]) {
        result = view;
        ddd_invertAttribute(attribute);
    }
    
    return result;
}

NS_INLINE void ddd_invertAttribute(NSLayoutAttribute *attribute)
{
    *attribute = ddd_inversionForAttribute(*attribute);
}

NS_INLINE NSLayoutAttribute ddd_inversionForAttribute(NSLayoutAttribute attribute)
{
    switch(attribute) {
        case NSLayoutAttributeBottom:
            return NSLayoutAttributeTop;
        case NSLayoutAttributeTop:
            return NSLayoutAttributeBottom;
        default: return attribute;
    }
}
@end
