//
//  DDDReactiveServices.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/22/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDReactiveServices.h"
#import "DDDHackernewsItemResponseSerializer.h"

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
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
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
        
        [self.httpRequestManager GET:endPoint
                          parameters:nil
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 // convert the response object into an array of models
                                 [subscriber sendNext:[DDDHackernewsItemResponseSerializer arrayOfItemsFromJSONArray:responseObject]];
                                 [subscriber sendCompleted];
                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [subscriber sendError:error];
                             }];
        return nil;
    }];
}

- (RACSignal *)fetchCommentsForStoryIdentifier:(NSNumber *)identifier
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (identifier == 0)
        {
            [subscriber sendError:[NSError errorWithDomain:@"Invalid identifier" code:-1 userInfo:nil]];
            return nil;
        }
        
        NSDictionary *paramsDictionary = @{
                                           @"storyID" : identifier,
                                           };
        NSString *endPoint = [NSString stringWithFormat:@"%@?%@", @"getComments", [paramsDictionary urlEncodedParameterString]];
        
        [self.httpRequestManager GET:endPoint
                              parameters:nil
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     // convert the response object into an array of models
                                     [subscriber sendNext:[DDDHackernewsItemResponseSerializer arrayOfItemsFromJSON:responseObject]];
                                     [subscriber sendCompleted];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [subscriber sendError:error];
                                 }];
        return nil;
    }];
}

@end
