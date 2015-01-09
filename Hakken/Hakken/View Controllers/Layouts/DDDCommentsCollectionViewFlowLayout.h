//
//  DDDCommentsCollectionViewLayout.h
//  Hakken
//
//  Created by Sidd Sathyam on 12/26/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDDCommentsViewModel;

/// The default resistance factor that determines the bounce of the collection. Default is 900.0f.
#define kScrollResistanceFactorDefault 900.0f;

@interface DDDCommentsCollectionViewFlowLayout : UICollectionViewFlowLayout
/// The scrolling resistance factor determines how much bounce / resistance the collection has. A higher number is less bouncy, a lower number is more bouncy. The default is 900.0f.
@property (nonatomic, assign) CGFloat scrollResistanceFactor;
@property (weak, nonatomic) DDDCommentsViewModel *commentsViewModel;

+ (instancetype)layoutWithCommentsViewModel:(DDDCommentsViewModel *)viewModel;
@end
