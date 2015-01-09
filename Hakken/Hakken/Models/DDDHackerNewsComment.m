//
//  DDDHackerNewsItem.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/20/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDHackerNewsComment.h"

@implementation DDDHackerNewsComment
- (void)setupPropertyMappingsWithDictionary:(NSDictionary *)dictionary
{
    [super setupPropertyMappingsWithDictionary:dictionary];
    [self setArrayOfModelsWithClass:[DDDHackerNewsComment class] forKey:@"kids"];
}
@end
