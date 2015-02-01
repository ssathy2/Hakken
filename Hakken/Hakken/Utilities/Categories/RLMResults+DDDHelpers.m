//
//  RLMResults+DDDHelpers.m
//  Hakken
//
//  Created by Sidd Sathyam on 2/1/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "RLMResults+DDDHelpers.h"

@implementation RLMResults (DDDHelpers)
- (NSArray *)arrayFromResults
{
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < self.count; i++)
        [arr addObject:[self objectAtIndex:i]];
    return arr;
}
@end
