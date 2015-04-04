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
- (CGSize)preferredLayoutSizeWithCellClass:(Class)cellClass withCellModel:(id)model withModelIdentifier:(NSString *)modelIdentifier;
@end
