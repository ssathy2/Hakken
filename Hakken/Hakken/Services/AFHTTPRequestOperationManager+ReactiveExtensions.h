//
//  AFHTTPRequestOperationManager+ReactiveExtensions.h
//  Hakken
//
//  Created by Sidd Sathyam on 2/8/16.
//  Copyright © 2016 dotdotdot. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

#define kAFNetworkingReactiveExtensionErrorInfoOperationKey @"kAFNetworkingReactiveExtensionErrorInfoOperationKey"

@interface AFHTTPRequestOperationManager (ReactiveExtensions)
- (RACSignal *)hakken_GETSignalWithURLString:(NSString *)urlString urlParameters:(NSDictionary *)urlParameters;
@end
