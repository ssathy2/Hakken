//
//  DDDHelpers.h
//  P2PTestApp
//
//  Created by Sidd Sathyam on 11/05/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#ifdef DEBUG
#define IS_DEVICE ([[[UIDevice currentDevice] model] rangeOfString:@"Simulator" options:NSCaseInsensitiveSearch].location == NSNotFound)
#else
#define IS_DEVICE YES
#endif

#import "DDDMock.h"