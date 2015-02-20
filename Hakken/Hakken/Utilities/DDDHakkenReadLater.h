//
//  DDDHakkenReadLater.h
//  Hakken
//
//  Created by Sidd Sathyam on 1/31/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDDHackerNewsItem;

@protocol DDDHakkenReadLater <NSObject>
@optional
+ (RACSignal *)addItemToReadLater:(DDDHackerNewsItem *)item;
+ (RACSignal *)removeItemFromReadLater:(DDDHackerNewsItem *)item;
+ (RACSignal *)fetchAllItemsToReadLater;
+ (RACSignal *)fetchUnreadReadLaterItems;
+ (RACSignal *)fetchReadReadLaterItems;

// The completion contains all of the items that were removed from the readlater queue
+ (RACSignal *)removeAllItemsFromReadLater;
@end
