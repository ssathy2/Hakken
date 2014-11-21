//
//  DDDMock.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/20/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDMock : NSObject
+ (NSDictionary *)dictionaryFromJSONFile:(NSString *)file;
@end
