//
//  DDDRowInsertionDeletion.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDArrayInsertionDeletion.h"

@interface DDDArrayInsertionDeletion()
@property (copy, nonatomic) NSArray *array;
@property (copy, nonatomic) NSIndexSet *indexesInserted;
@property (copy, nonatomic) NSIndexSet *indexesDeleted;

@property (strong, nonatomic) RACSignal *arrayChangedSignal;
@property (copy, nonatomic) NSHashTable *signalSubscribers;
@end

@implementation DDDArrayInsertionDeletion
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self)
        [self sharedInit];
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
        [self sharedInit];
    return self;
}

- (void)sharedInit
{
    self.signalSubscribers  = [NSHashTable hashTableWithOptions:NSPointerFunctionsStrongMemory];
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
    self.indexesInserted                = nil;
    [self updateSignalSubscribers];
}

- (void)addAllItemsIntoArrayFromArray:(NSArray *)array
{
    NSMutableArray *scratchArray         = [NSMutableArray arrayWithArray:self.array];
    NSMutableIndexSet *indexSetAdded     = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(self.array.count, array.count)];
    [scratchArray addObjectsFromArray:array];
    self.array                           = scratchArray;
    self.indexesInserted                 = indexSetAdded;
    self.indexesDeleted                  = nil;
    [self updateSignalSubscribers];
}

- (void)updateItemAtIndex:(NSInteger)index withItems:(id)object
{
    NSAssert(object != nil, @"'object' parameter to %@ cannot be nil", NSStringFromSelector(_cmd));
    NSMutableArray *scratchArray = [NSMutableArray arrayWithArray:self.array];
    scratchArray[index] = object;
    self.array = scratchArray;
    self.indexesDeleted  = [NSIndexSet indexSetWithIndex:index];
    self.indexesInserted = [NSIndexSet indexSetWithIndex:index];
    [self updateSignalSubscribers];
}

- (void)updateItemsAtIndexes:(NSIndexSet *)indexesToUpdate withItems:(NSArray *)items
{
    NSAssert(items != nil, @"'object' parameter to %@ is nil", NSStringFromSelector(_cmd));
    NSMutableArray *scratchArray = [NSMutableArray arrayWithArray:self.array];
    NSUInteger currentIndex = [indexesToUpdate firstIndex];
    while (currentIndex != NSNotFound) {
        scratchArray[currentIndex] = items[currentIndex];
        currentIndex = [indexesToUpdate indexGreaterThanIndex:currentIndex];
    }
    self.array = scratchArray;
    self.indexesDeleted  = indexesToUpdate;
    self.indexesInserted = indexesToUpdate;
    [self updateSignalSubscribers];
}

- (void)updateSignalSubscribers
{
    for (id<RACSubscriber> subscriber in self.signalSubscribers)
    {
        [subscriber sendNext:self];
    }
}
@end
