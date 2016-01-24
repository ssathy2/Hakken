//
//  DDDRowInsertionDeletion.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDModel.h"

@interface DDDArrayInsertionDeletion : DDDModel
@property (copy, nonatomic, readonly) NSArray *array;
@property (copy, nonatomic, readonly) NSIndexSet *indexesInserted;
@property (copy, nonatomic, readonly) NSIndexSet *indexesDeleted;

@property (strong, nonatomic, readonly) RACSignal *arrayChangedSignal;

/*
 - Empties out all of the contents of the existing array,
 - sets the indexesDeleted to the indexes of the deleted array
 - sets the indexes inserted to the indexes of the parameter array
 */
- (void)resetArrayWithArray:(NSArray *)array;

// Removes the items from the array at the indexes removed
- (void)removeIndexesFromArray:(NSIndexSet *)indexesToRemove;

// Updates the item at parameter idx with the parameter item
- (void)updateItemAtIndex:(NSInteger)index withItems:(id)object;

// Updates the items at parameter indexes with the parameter items
- (void)updateItemsAtIndexes:(NSIndexSet *)indexesToUpdate withItems:(NSArray *)items;

// Adds all of the items in the parameter array to the internal array, indexesInserted gets updated
- (void)addAllItemsIntoArrayFromArray:(NSArray *)array;
@end
