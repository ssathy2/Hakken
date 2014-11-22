//
//  DDDReactiveServices.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/22/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDReactiveServices.h"

@interface DDDReactiveServices()
@property (strong, nonatomic) AFHTTPRequestOperationManager *httpRequestManager;
@end

@implementation DDDReactiveServices
+ (instancetype) sharedInstance
{
    static DDDReactiveServices* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DDDReactiveServices alloc] init];
        // do any init for the shared instance here
        [sharedInstance setupFromConfiguration];
    });
    return sharedInstance;
}

- (void)setupFromConfiguration
{
    NSDictionary *configuration             = [DDDMock dictionaryFromJSONFile:@"Configuration"];
    NSDictionary *servicesConfiguration     = [DDDMock dictionaryFromJSONFile:@"ServicesConfiguration"];
    
    NSString *servicesKey = configuration[@"services"];

    NSDictionary *servicesDictionary        = servicesConfiguration[servicesKey];
    
    NSURL *baseURL = [NSURL URLWithString:servicesDictionary[@"baseURL"]];
    self.httpRequestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
}

- (RACSignal *)fetchTopStoriesFromStory:(NSNumber *)fromStory toStory:(NSNumber *)toStory
{
    NSString *endPoint;
    if (fromStory == 0 || toStory == 0)
        endPoint = [NSString stringWithFormat:@"%@", @"getTopStories"];
    else
    {
        NSDictionary *paramsDictionary = @{
                                           @"fromStory" : fromStory,
                                           @"toStory"   : toStory
                                           };
        endPoint = [NSString stringWithFormat:@"%@?%@", @"getTopStories", [paramsDictionary urlEncodedParameterString]];
    }
    
    __weak typeof(self) weakSelf = self;
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [weakSelf.httpRequestManager GET:endPoint
                          parameters:nil
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [subscriber sendNext:responseObject];
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 
                             }];
        return nil;
    }];
}

- (RACSignal *)fetchStoryWithIdentifier:(NSNumber *)identifier
{
    
}

- (RACSignal *)fetchTopStories
{
    
}

@end
