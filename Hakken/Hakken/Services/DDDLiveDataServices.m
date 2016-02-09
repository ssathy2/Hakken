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
#import "DDDHakkenReadLaterInformation.h"

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
        self.httpRequestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    return self;
}

- (RACSignal *)fetchTopStoriesFromStory:(NSNumber *)fromStory toStory:(NSNumber *)toStory
{
    NSString *endPoint;
    NSDictionary *paramsDictionary;
    if (fromStory == 0 || toStory == 0)
        endPoint = [NSString stringWithFormat:@"%@", @"getTopStories"];
    else
    {
        paramsDictionary = @{
                             @"fromStory" : fromStory,
                             @"toStory"   : toStory
                             };
        endPoint = [NSString stringWithFormat:@"%@", @"getTopStories"];
    }

    return [[self.httpRequestManager hakken_GETSignalWithURLString:endPoint urlParameters:paramsDictionary] map:^id(AFHTTPRequestOperation *operation) {
        NSMutableArray *arr = [NSMutableArray array];
        [[RLMRealm defaultRealm] beginWriteTransaction];
        [operation.responseObject enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL *stop) {
            if ([self shouldModelHackernewsResponseDictionary:item])
            {
                DDDHackerNewsItem *servicesItem = [[DDDHackerNewsItem alloc] initWithObject:[self remappedResponseDictionaryWithOriginalDictionary:item shouldPerformKidsRemapping:YES]];
                DDDHackerNewsItem *realmItem = [DDDHackerNewsItem objectForPrimaryKey:@(servicesItem.id)];
                if (servicesItem.deleted == NO)
                {
                    if (!realmItem.readLaterInformation)
                        realmItem.readLaterInformation = [DDDHakkenReadLaterInformation defaultObject];
                    servicesItem.readLaterInformation = realmItem.readLaterInformation;
                    [arr addObject:servicesItem];
                }
            }
        }];
        [[RLMRealm defaultRealm] addOrUpdateObjectsFromArray:arr];
        [[RLMRealm defaultRealm] commitWriteTransaction];
        return arr;
    }];
}

- (RACSignal *)fetchCommentsForStoryIdentifier:(NSNumber *)identifier
{
    if (!identifier)
        return nil;
    NSDictionary *paramsDictionary = @{
                                       @"storyID" : identifier,
                                       };
    NSString *endPoint = [NSString stringWithFormat:@"%@", @"getComments"];
    
    return [[self.httpRequestManager hakken_GETSignalWithURLString:endPoint urlParameters:paramsDictionary] map:^id(AFHTTPRequestOperation *operation) {
        NSMutableArray *arr = [NSMutableArray array];
        [[RLMRealm defaultRealm] beginWriteTransaction];
        [operation.responseObject enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL *stop) {
            if ([self shouldModelHackernewsResponseDictionary:item])
                [arr addObject:[[DDDHackerNewsComment alloc] initWithObject:[self remappedResponseDictionaryWithOriginalDictionary:item shouldPerformKidsRemapping:NO]]];
        }];
        [[RLMRealm defaultRealm] addOrUpdateObjectsFromArray:arr];
        [[RLMRealm defaultRealm] commitWriteTransaction];
        return arr;
    }];
}

- (BOOL)shouldModelHackernewsResponseDictionary:(NSDictionary *)responseDictionary
{
    return (![responseDictionary valueForKey:@"error"]);
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
    
    [[self numberToStringPropertyConverionArray] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSNumber *numVal = [mutableOriginalDictionary valueForKey:key];
        NSString *stringNumVal = [numVal stringValue];
        if (stringNumVal)
            [mutableOriginalDictionary setObject:stringNumVal forKey:key];
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
    return nil;
}

- (NSArray *)numberToStringPropertyConverionArray
{
    return nil;
}

@end
