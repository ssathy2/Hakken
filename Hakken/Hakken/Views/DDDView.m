//
//  DDDView.m
//  Hakken
//
//  Created by Sidd Sathyam on 2/13/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

#import "DDDView.h"

@implementation DDDView
- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    if(!self.class.isReplaceable || self.subviews.count) {
        return self;
    }
    
    DDDView *replacement = [self.class ddd_loadInstanceFromNib];
    
    // synchronize missing properties
    replacement.tag   = self.tag;
    replacement.frame = self.frame;
    replacement.translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints;
    
    // migrate constraints
    [replacement addConstraints:[self ddd_migrateConstraintsToView:replacement]];
    
    return replacement;
}

#pragma mark - Replaceability

+ (BOOL)isReplaceable
{
    return NO;
}
@end
