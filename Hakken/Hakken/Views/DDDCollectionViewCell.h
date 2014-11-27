//
//  DDDCollectionViewCell.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/26/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDDCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) id model;

- (void)prepareWithModel:(id)model;
@end
