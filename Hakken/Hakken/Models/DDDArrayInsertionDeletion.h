//
//  DDDRowInsertionDeletion.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDModel.h"

@interface DDDArrayInsertionDeletion : DDDModel
@property (weak  , nonatomic) NSArray *array;
@property (strong, nonatomic) NSIndexSet *indexesInserted;
@property (strong, nonatomic) NSIndexSet *indexesDeleted;
@end
