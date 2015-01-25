//
//  DDDReactiveServices.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/22/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDLiveDataServices.h"
#import "DDDHackerNewsItem.h"
#import "DDDHackerNewsComment.h"
#import "DDDHackernewsItemResponseSerializer.h"

@class DDDHackerNewsItem, DDDHackerNewsComment;

@interface DDDLiveDataServices()
@property (strong, nonatomic) AFHTTPRequestOperationManager *httpRequestManager;
@end

@implementation DDDLiveDataServices
+ (instancetype)liveServicesWithBaseURL:(NSURL *)baseURL
{
    return [[DDDLiveDataServices alloc] initWithBaseURL:baseURL];
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        self.httpRequestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
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
                                 NSMutableArray *arr = [NSMutableArray array];
                                 [[RLMRealm defaultRealm] beginWriteTransaction];
                                 for (NSDictionary *item in responseObject)
                                     [arr addObject:[[DDDHackerNewsItem alloc] initWithObject:[self remappedResponseDictionaryWithOriginalDictionary:item shouldPerformKidsRemapping:YES]]];
                                 [[RLMRealm defaultRealm] commitWriteTransaction];
                                 [subscriber sendNext:arr];
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
                                     NSMutableArray *arr = [NSMutableArray array];
                                     [[RLMRealm defaultRealm] beginWriteTransaction];
                                     for (NSDictionary *item in responseObject)
                                         [arr addObject:[[DDDHackerNewsComment alloc] initWithObject:[self remappedResponseDictionaryWithOriginalDictionary:item shouldPerformKidsRemapping:NO]]];
                                     [[RLMRealm defaultRealm] commitWriteTransaction];
                                     [subscriber sendNext:arr];
                                     [subscriber sendCompleted];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [subscriber sendError:error];
                                 }];
        return nil;
    }];
}

- (NSDictionary *)remappedResponseDictionaryWithOriginalDictionary:(NSDictionary *)originalDictionary shouldPerformKidsRemapping:(BOOL)shouldPerformKidsRemapping
{
    // basically we want to take the mappings in the original dictionary and based on the Key-value pairs in remapDictionary, perform the remapping
    NSDictionary *remapDictionary = [self remapDictionary];
    NSMutableDictionary *mutableOriginalDictionary = [NSMutableDictionary dictionaryWithDictionary:originalDictionary];
    [remapDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        id object = [originalDictionary valueForKey:key];
        NSString *convertedObject;
        if ([object isKindOfClass:[NSNumber class]])
            convertedObject = [(NSNumber *)object stringValue];
        
        [mutableOriginalDictionary setValue:(convertedObject)?:object forKey:value];
        [mutableOriginalDictionary removeObjectForKey:key];
    }];
    
    if (shouldPerformKidsRemapping)
    {
        NSArray *originalKidsArray = [[mutableOriginalDictionary valueForKey:@"kids"] copy];
        NSArray *newKidsArray = [self customRemappedKidsArrayFromOriginalKidsArray:originalKidsArray];
        [mutableOriginalDictionary setObject:newKidsArray forKey:@"kids"];
    }
    
    return mutableOriginalDictionary;
}

// UGLY AS HELL
- (NSArray *)customRemappedKidsArrayFromOriginalKidsArray:(NSArray *)array
{
    NSMutableArray *remappedKidsArray = [NSMutableArray array];
    for (NSNumber *kid in array)
    {
        [remappedKidsArray addObject:@{
                                      @"identifier" : [kid stringValue]
                                      }];
    }
    return remappedKidsArray;
}

- (NSDictionary *)remapDictionary
{
    return @{
             @"id" : @"identifier"
             };
}

@end
