//
//  DDDBouncyCollectionViewFlowLayout.m
//  Hakken
//
//  Created by Sidd Sathyam on 1/8/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "DDDBouncyCollectionViewFlowLayout.h"

@interface DDDBouncyCollectionViewFlowLayout()
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) NSMutableSet *visibleIndexPaths;
@property (nonatomic, assign) CGFloat latestDelta;
@end

@implementation DDDBouncyCollectionViewFlowLayout
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        [self sharedInit];
    }
    return self;
}

- (void)sharedInit
{

}

- (void)prepareLayout
{
    [super prepareLayout];
}
@end
