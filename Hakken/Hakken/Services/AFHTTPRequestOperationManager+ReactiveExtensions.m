//
//  AFHTTPRequestOperationManager+ReactiveExtensions.m
//  Hakken
//
//  Created by Sidd Sathyam on 2/8/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

#import "AFHTTPRequestOperationManager+ReactiveExtensions.h"

@implementation AFHTTPRequestOperationManager (ReactiveExtensions)
- (RACSignal *)hakken_GETSignalWithURLString:(NSString *)urlString urlParameters:(NSDictionary *)urlParameters
{
    return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        AFHTTPRequestOperation *op = [self GET:urlString parameters:urlParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:operation];
            [subscriber sendCompleted];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSMutableDictionary *userInfo = [error.userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
            userInfo[kAFNetworkingReactiveExtensionErrorInfoOperationKey] = operation;
            NSError *errorWithOperation = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
            [subscriber sendError:errorWithOperation];
        }];
        return [RACDisposable disposableWithBlock:^{
            [op cancel];
        }];
    }] replayLazily];
}
@end
