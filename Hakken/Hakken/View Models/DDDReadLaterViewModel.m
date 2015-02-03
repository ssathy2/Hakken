//
//  DDDReadLaterViewModel.m
//  Hakken
//
//  Created by Sidd Sathyam on 2/1/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "DDDReadLaterViewModel.h"
#import "DDDArrayInsertionDeletion.h"
#import "DDDHakkenReadLaterManager.h"

@implementation DDDReadLaterViewModel
- (void)viewModelDidLoad
{
    [super viewModelDidLoad];
    __weak typeof(self) weakSelf = self;
    [DDDHakkenReadLaterManager fetchAllItemsToReadLaterWithCompletion:^(NSArray *items) {
        DDDArrayInsertionDeletion *insertionDeletion    = [DDDArrayInsertionDeletion new];
        insertionDeletion.array                         = items;
        insertionDeletion.indexesDeleted                = nil;
        insertionDeletion.indexesInserted               = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, (items.count == 0) ? 0 : items.count-1)];
        weakSelf.latestStoriesUpdate                    = insertionDeletion;
    } withError:^(NSError *error) {
       
    }];
}
@end
