//
//  DDDReactiveServices.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/22/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDReactiveServices : NSObject
+ (instancetype)sharedInstance;

// Returns a RACSignal that contains the result of the network calls
- (RACSignal *)fetchTopStoriesFromStory:(NSNumber *)fromStory toStory:(NSNumber *)toStory;
- (RACSignal *)fetchCommentsForStoryIdentifier:(NSNumber *)identifier;
@end
