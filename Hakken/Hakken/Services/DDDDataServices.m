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

@import ObjectiveC;

#define DDDMockServicesValue @"mock"

@interface DDDDataServices()
@property (strong, nonatomic) id<DDDServices> services;
@end

@implementation DDDDataServices

/*
    We use an associated object to store the data services object on the class,
    doing this allows us to basically take the data services object and change configurations
    at runtime.
*/
+ (DDDDataServices *)cachedDataServices
{
    static DDDDataServices *dataServices = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        dataServices = [DDDDataServices new];
        [dataServices setupFromConfiguration:DDDDefaultConfigurationFilename withServicesConfiguration:DDDDefaultDataServicesConfigurationFileName];
    });
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    return objc_getAssociatedObject(self, @selector(cachedDataServices)) ?: dataServices;
#pragma clang diagnostic pop
}

+ (void)setCachedDataServices:(DDDDataServices *)dataServices
{
    objc_setAssociatedObject(self, @selector(cachedDataServices), dataServices, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (instancetype)sharedInstance
{
    return [self cachedDataServices];
}

+ (instancetype)sharedInstanceWithConfiguration:(NSString *)configurationFilename withServicesConfiguration:(NSString *)servicesConfigurationFilename;
{
    DDDDataServices *dataServices = [self cachedDataServices];
    [dataServices setupFromConfiguration:configurationFilename withServicesConfiguration:servicesConfigurationFilename];
    return dataServices;
}

- (void)setupFromConfiguration:(NSString *)configurationFilename withServicesConfiguration:(NSString *)servicesConfigurationFilename
{
    __block NSString *servicesKey;
    __block NSDictionary *servicesConfiguration;
    [[[[DDDFileOperationHelpers dictionaryFromJSONFile:configurationFilename async:NO] flattenMap:^RACStream *(NSDictionary *configuration) {
        return [RACSignal return:configuration[@"services"]];
    }]
    concat:[DDDFileOperationHelpers dictionaryFromJSONFile:servicesConfigurationFilename async:NO]]
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
