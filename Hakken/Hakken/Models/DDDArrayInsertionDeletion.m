//
//  DDDRowInsertionDeletion.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDArrayInsertionDeletion.h"

@interface DDDArrayInsertionDeletion()
@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) NSIndexSet *indexesInserted;
@property (strong, nonatomic) NSIndexSet *indexesDeleted;

@property (strong, nonatomic) RACSignal *arrayChangedSignal;
@property (strong, nonatomic) NSHashTable *signalSubscribers;
@end

@implementation DDDArrayInsertionDeletion
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self)
    {
        [self sharedInit];
    }
    return self;
}

- (id)init
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
    self.signalSubscribers  = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    __weak typeof(self) weakSelf = self;
    self.arrayChangedSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [weakSelf.signalSubscribers addObject:subscriber];
        return nil;
    }];
}

- (void)resetArrayWithArray:(NSArray *)array
{
    NSMutableIndexSet *indexesRemoved   = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.array.count)];
    NSMutableIndexSet *indexesAdded     = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)];
    self.array                          = array;
    self.indexesDeleted                 = indexesRemoved;
    self.indexesInserted                = indexesAdded;
    [self updateSignalSubscribers];
}

- (void)removeIndexesFromArray:(NSIndexSet *)indexesToRemove
{
    NSMutableArray *scratchArray        = [NSMutableArray arrayWithArray:self.array];
    [scratchArray removeObjectsAtIndexes:indexesToRemove];
    self.array                          = scratchArray;
    self.indexesDeleted                 = indexesToRemove;
    [self updateSignalSubscribers];
}

- (void)addAllItemsIntoArrayFromArray:(NSArray *)array
{
    NSMutableArray *scratchArray         = [NSMutableArray arrayWithArray:self.array];
    NSMutableIndexSet *indexSetAdded     = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(self.array.count, array.count)];
    [scratchArray addObjectsFromArray:array];
    self.array = scratchArray;
    self.indexesInserted = indexSetAdded;
    [self updateSignalSubscribers];
}

- (void)updateSignalSubscribers
{
    for (id<RACSubscriber> subscriber in self.signalSubscribers)
        [subscriber sendNext:self];
}
@end
