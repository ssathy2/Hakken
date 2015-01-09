//
//  DDDStoryDetailViewModel.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/29/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDViewModel.h"
#import "DDDStoryTransitionModel.h"

@interface DDDStoryDetailViewModel : DDDViewModel
@property (strong, nonatomic, readonly) DDDStoryTransitionModel *transitionModel;
@end
