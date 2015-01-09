//
//  DDDHelpers.m
//  Hakken
//
//  Created by Sidd Sathyam on 12/29/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDHelpers.h"

@implementation DDDHelpers
+ (RACSignal *)arrayFromJSONFile:(NSString *)file
                           async:(BOOL)async
{
    return [[self internalJSONHelper:file async:async]
            filter:^BOOL(id value) {
                return [value isKindOfClass:NSArray.class];
            }];
}

+ (RACSignal *)internalJSONHelper:(NSString *)fileName
                            async:(BOOL)async
{
    RACSignal *signal = [self dataFromFileName:fileName withExtension:@"json" async:async];
    signal = [signal filter:^BOOL(id value) {
        return value != nil;
    }];
    return [signal flattenMap:^RACStream *(id value) {
        return [RACSignal return:[NSJSONSerialization JSONObjectWithData:value options:0 error:nil]];
    }];
}

+ (RACSignal *)dataFromFileName:(NSString *)fileName
                  withExtension:(NSString *)extension
                          async:(BOOL)async
{
    assert(fileName.length > 0);
    assert(extension.length > 0);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        void(^dataFetchBlock)() = ^() {
            NSBundle *bundle = [NSBundle mainBundle];
            NSString *fullFilePath = [bundle pathForResource:fileName ofType:extension];
            if (!fullFilePath)
                [subscriber sendError:[NSError errorWithDomain:@"File not found in default bundle" code:-1 userInfo:nil]];
            else
            {
                NSData *rawData = [[NSData alloc] initWithContentsOfFile:fullFilePath options:NSDataReadingMappedIfSafe error:nil];
                [subscriber sendNext:rawData];
                [subscriber sendCompleted];
            }
        };
        
        if (async)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dataFetchBlock();
            });
        }
        else
            dataFetchBlock();
        
        return nil;
    }];
}

+ (RACSignal *)dictionaryFromJSONFile:(NSString *)file
                                async:(BOOL)async
{
    return [[self internalJSONHelper:file async:async]
                filter:^BOOL(id value) {
                    return [value isKindOfClass:NSDictionary.class];
            }];
}
@end
