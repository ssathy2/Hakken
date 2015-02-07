//
//  DDDStoryDisplayVIewModel.m
//  Hakken
//
//  Created by Sidd Sathyam on 1/9/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "DDDStoryDisplayViewModel.h"

@implementation DDDStoryDisplayViewModel
- (void)saveStoryToReadLater:(DDDHackerNewsItem *)story completion:(DDDHackerNewsItemBlock)completion error:(ErrorBlock)error
{
    [DDDHakkenReadLaterManager addItemToReadLater:story withCompletion:completion withError:error];
}

- (void)removeStoryFromReadLater:(DDDHackerNewsItem *)story completion:(DDDHackerNewsItemBlock)completion error:(ErrorBlock)error
{
    [DDDHakkenReadLaterManager removeItemFromReadLater:story withCompletion:completion withError:error];
}
@end
