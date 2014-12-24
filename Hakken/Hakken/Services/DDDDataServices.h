//
//  DDDDataServices.h
//  Hakken
//
//  Created by Sidd Sathyam on 12/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDDServices.h"

@interface DDDDataServices : NSObject<DDDServices>
+ (instancetype)sharedInstance;
@end
