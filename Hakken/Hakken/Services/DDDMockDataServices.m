//
//  DDDMockDataServices.m
//  Hakken
//
//  Created by Sidd Sathyam on 12/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDMockDataServices.h"
#import "DDDHackerNewsComment.h"
#import "DDDHackernewsItemResponseSerializer.h"

@implementation DDDMockDataServices
- (RACSignal *)fetchTopStoriesFromStory:(NSNumber *)fromStory toStory:(NSNumber *)toStory
{
    // Load in mock story

    return [[[DDDFileOperationHelpers arrayFromJSONFile:@"mock_top_stories" async:YES]
                         filter:^BOOL(id value) {
                             return value != nil;
                         }]
            flattenMap:^RACStream *(id value) {
                return [RACSignal return:[DDDHackernewsItemResponseSerializer arrayOfItemsFromJSONArray:value]];
            }];
}

- (RACSignal *)fetchCommentsForStoryIdentifier:(NSNumber *)identifier
{
    // Load in mock comments
    return [[[DDDFileOperationHelpers arrayFromJSONFile:@"mock_getcomments" async:YES]
             filter:^BOOL(id value) {
                 return value != nil;
             }]
            flattenMap:^RACStream *(id value) {
                return [RACSignal return:[DDDHackernewsItemResponseSerializer arrayOfCommentsFromJSONArray:value]];
            }];
}
@end
