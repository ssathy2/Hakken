//
//  DDDHakkenReadLaterInformation.h
//  Hakken
//
//  Created by Sidd Sathyam on 1/31/15.
//  Copyright (c) 2015 dotdotdot. All rights reserved.
//

#import "RLMObject.h"

@interface DDDHakkenReadLaterInformation : RLMObject
// Properties for save later functionality
@property (assign, nonatomic) BOOL userWantsToReadLater;
@property (strong, nonatomic) NSDate *dateUserInitiallySavedToReadLater;
@property (strong, nonatomic) NSDate *dateUserSavedToReadLater;
@property (strong, nonatomic) NSDate *dateUserLastRead;

// Generated and Ignored properties
@property (assign, nonatomic) BOOL hasUserReadItem;

+ (instancetype)defaultObject;
@end
