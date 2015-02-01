//
//  DDDHakkenReadLater.h
//  Hakken
//
//  Created by Sidd Sathyam on 1/31/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDDHackerNewsItem;

typedef void(^ErrorBlock)(NSError *error);
typedef void(^DDDHackerNewsItemBlock)(DDDHackerNewsItem *item);

// Array in parameter to block has objects of type DDDHackerNewsItem
typedef void(^DDDHackerNewsItemArrayBlock)(NSArray *items);

@protocol DDDHakkenReadLater <NSObject>
@optional
+ (void)addItemToReadLater:(DDDHackerNewsItem *)item withCompletion:(DDDHackerNewsItemBlock)completion withError:(ErrorBlock)error;
+ (void)removeItemFromReadLater:(DDDHackerNewsItem *)item withCompletion:(DDDHackerNewsItemBlock)completion withError:(ErrorBlock)error;
+ (void)fetchAllItemsToReadLaterWithCompletion:(DDDHackerNewsItemArrayBlock)completion withError:(NSError *)error;
+ (void)fetchUnreadReadLaterItemsWithCompletion:(DDDHackerNewsItemArrayBlock)completion withError:(NSError *)error;
+ (void)fetchReadReadLaterItemsWithCompletion:(DDDHackerNewsItemArrayBlock)completion withError:(NSError *)error;

// The completion contains all of the items that were removed from the readlater queue
+ (void)removeAllItemsFromReadLaterWithCompletion:(DDDHackerNewsItemArrayBlock)completion withError:(NSError *)error;
@end
