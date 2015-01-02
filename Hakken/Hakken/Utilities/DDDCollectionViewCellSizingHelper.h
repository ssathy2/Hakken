//
//  DDDCollectionViewCellSizingHelper.h
//  Hakken
//
//  Created by Sidd Sathyam on 1/2/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDCollectionViewCellSizingHelper : NSObject
+ (instancetype)sharedInstance;
// Sizing helper uses cell class name to instantiate a nib with the cell
- (CGSize)adjustedCellSizeWithCellClass:(Class)cellClass withCellModel:(id)model withCellModelIdentifier:(id)identifier;
@end
