//
//  DDDTopStoriesCollectionViewCell.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/26/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDDCollectionViewCell.h"

#define DDDTopStoriesCollectionViewCellIdentifier @"DDDTopStoriesCollectionViewCell"

typedef NS_ENUM(NSInteger, DDDCellCollapseState)
{
    DDDCellCollapseStateCollapsed,
    DDDCellCollapseStateNotCollapsed
};

@interface DDDTopStoriesCollectionViewCell : DDDCollectionViewCell
- (void)setCellState:(DDDCellCollapseState)state;
- (void)loadURLIfNecessary;
@end
