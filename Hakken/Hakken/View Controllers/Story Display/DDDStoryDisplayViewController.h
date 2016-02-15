//
//  DDDTopStoriesViewController.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewController.h"
#import "DDDHackerNewsItemCollectionViewCell.h"

@class DDDArrayInsertionDeletion;

@interface DDDStoryDisplayViewController : DDDViewController<DDDHackerNewsItemCollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)updateWithInsertionDeletion:(DDDArrayInsertionDeletion *)insertionDeletion;
@end
