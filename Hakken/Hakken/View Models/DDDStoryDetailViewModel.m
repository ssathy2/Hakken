//
//  DDDStoryDetailViewModel.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/29/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDStoryDetailViewModel.h"
#import "DDDStoryDetailTransitionModel.h"

@interface DDDStoryDetailViewModel()
@property (strong, nonatomic) DDDStoryDetailTransitionModel *transitionModel;
@end
@implementation DDDStoryDetailViewModel
- (void)prepareWithModel:(id)model
{
    [super prepareWithModel:model];
    DDDStoryDetailTransitionModel *transitionModel = (DDDStoryDetailTransitionModel *)model;
    self.transitionModel = transitionModel;
}

- (void)viewModelDidLoad
{
    [super viewModelDidLoad];
}
@end
