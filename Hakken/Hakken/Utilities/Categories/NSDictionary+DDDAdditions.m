//
//  NSDictionary+DDDAdditions.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/22/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "NSDictionary+DDDAdditions.h"

@implementation NSDictionary (DDDAdditions)
- (NSString *)urlEncodedParameterString
{
    NSMutableArray *components = [NSMutableArray array];
    for (NSString *key in self)
        [components addObject:[NSString stringWithFormat:@"%@=%@", key, self[key]]];
    
    return [components componentsJoinedByString:@"&"];
}
@end
