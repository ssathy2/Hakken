//
//  DDDMock.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/20/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DataBlock)(NSData *data);
typedef void(^ErrorBlock)(NSError *error);

@interface DDDMock : NSObject
+ (RACSignal *)dictionaryFromJSONFile:(NSString *)file
                                async:(BOOL)async;

+ (RACSignal *)arrayFromJSONFile:(NSString *)file
                           async:(BOOL)async;


+ (RACSignal *)dataFromFileName:(NSString *)fileName
                  withExtension:(NSString *)extension
                          async:(BOOL)async;
@end
