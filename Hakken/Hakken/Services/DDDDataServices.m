//
//  DDDDataServices.m
//  Hakken
//
//  Created by Sidd Sathyam on 12/24/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDDataServices.h"
#import "DDDLiveDataServices.h"
#import "DDDMockDataServices.h"

#define DDDMockServicesValue @"mock"

@interface DDDDataServices()
@property (strong, nonatomic) id<DDDServices> services;
@end

@implementation DDDDataServices
+ (instancetype)sharedInstance
{
    static DDDDataServices* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DDDDataServices alloc] init];
        // do any init for the shared instance here
        [sharedInstance setupFromConfiguration];
    });
    return sharedInstance;
}

- (void)setupFromConfiguration
{
    __block NSString *servicesKey;
    __block NSDictionary *servicesConfiguration;
    [[[[DDDMock dictionaryFromJSONFile:@"Configuration" async:NO] flattenMap:^RACStream *(NSDictionary *configuration) {
        return [RACSignal return:configuration[@"services"]];
    }]
    concat:[DDDMock dictionaryFromJSONFile:@"ServicesConfiguration" async:NO]]
    subscribeNext:^(id x) {
       if ([x isKindOfClass:[NSString class]])
           servicesKey = (NSString *)x;
       if ([x isKindOfClass:[NSDictionary class]])
           servicesConfiguration = (NSDictionary *)x;
    } error:^(NSError *error) {
        DDLogError(@"%@", error);
    } completed:^{
        if ([[servicesKey lowercaseString] isEqualToString:DDDMockServicesValue])
            [self setupMockServices];
        else
            [self setupLiveServicesWithServicesDictionary:servicesConfiguration[servicesKey]];
    }];
}

- (void)setupMockServices
{
    self.services = [DDDMockDataServices new];
}

- (void)setupLiveServicesWithServicesDictionary:(NSDictionary *)servicesDictionary
{
    NSURL *baseURL = [NSURL URLWithString:servicesDictionary[@"baseURL"]];
    self.services = [DDDLiveDataServices liveServicesWithBaseURL:baseURL];
}

#pragma mark - DDDServices
- (RACSignal *)fetchCommentsForStoryIdentifier:(NSNumber *)identifier
{
    return [self.services fetchCommentsForStoryIdentifier:identifier];
}

- (RACSignal *)fetchTopStoriesFromStory:(NSNumber *)fromStory toStory:(NSNumber *)toStory
{
    return [self.services fetchTopStoriesFromStory:fromStory toStory:toStory];
}

@end
