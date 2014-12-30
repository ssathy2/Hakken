//
//  DDDDataServices.h
//  Hakken
//
//  Created by Sidd Sathyam on 12/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDDServices.h"

#define DDDDefaultConfigurationFilename @"Configuration"
#define DDDDefaultDataServicesConfigurationFileName @"ServicesConfiguration"

@interface DDDDataServices : NSObject<DDDServices>
+ (instancetype)sharedInstance;
+ (instancetype)sharedInstanceWithConfiguration:(NSString *)configurationFilename withServicesConfiguration:(NSString *)servicesConfigurationFilename;
@end
