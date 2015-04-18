//
//  DDDStoryDetailViewModel.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/29/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDStoryDetailViewModel.h"
#import "DDDStoryTransitionModel.h"
#import "DDDHakkenReadLaterManager.h"

@interface DDDStoryDetailViewModel()
@property (strong, nonatomic) DDDStoryTransitionModel *transitionModel;
@end
@implementation DDDStoryDetailViewModel
- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    DDDStoryTransitionModel *transitionModel = (DDDStoryTransitionModel *)model;
    self.transitionModel = transitionModel;
}

- (RACSignal *)markStoryAsRead
{
    return [DDDHakkenReadLaterManager markStoryAsRead:self.transitionModel.story];
}
@end
