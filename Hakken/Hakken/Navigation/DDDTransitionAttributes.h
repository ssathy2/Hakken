//
//  DDDTransitionAttributes.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/23/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDModel.h"

@interface DDDTransitionAttributes : DDDModel
@property (assign, nonatomic) BOOL presentModally;
@property (assign, nonatomic) BOOL shouldBeRoot;
@property (strong, nonatomic) id model;
@end
