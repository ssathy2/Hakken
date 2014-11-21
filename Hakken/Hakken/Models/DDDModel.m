//
//  DDDModel.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/17/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDModel.h"

typedef NS_ENUM(NSInteger, DDDModelMappingType)
{
    DDDModelMappingTypeSingleModel,
    DDDModelMappingTypeMultipleModel,
    DDDModelMappingTypeEnumerationType
};

@protocol DDDMapping <NSObject>
@property (nonatomic, assign) DDDModelMappingType mappingType;
@end

@interface DDDModelMapping : NSObject<DDDMapping>
@property (nonatomic, assign) Class modelClass;
@property (nonatomic, assign) DDDModelMappingType mappingType;
@end

@interface DDDEnumerationMapping : NSObject<DDDMapping>
@property (nonatomic, strong) NSDictionary *enumerationMapping;
@property (nonatomic, assign) DDDModelMappingType mappingType;
@end

@implementation DDDModelMapping
@end

@implementation DDDEnumerationMapping
@end

@interface DDDModel()
@property (strong, nonatomic) NSMutableDictionary *propertyMappings;
@end

@implementation DDDModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.propertyMappings = [NSMutableDictionary dictionary];
        [self prepareWithAttributes:dictionary];
    }
    return self;
}

#pragma mark - NSCoder
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    // TODO: obviously...
    return nil;
}

#pragma mark - Mappings

- (void)setEnumerationMapping:(NSDictionary *)enumerationMapping forKey:(NSString *)key
{
    DDDEnumerationMapping *enumerationObject = [self.propertyMappings valueForKey:key];
    if (!enumerationObject)
        enumerationObject = [DDDEnumerationMapping new];
    
    enumerationObject.enumerationMapping = enumerationMapping;
    enumerationObject.mappingType        = DDDModelMappingTypeEnumerationType;
    [self.propertyMappings setValue:enumerationObject forKey:key];
}

- (void)setModelClass:(Class)klass forKey:(NSString *)key
{
    DDDModelMapping *modelMapping = [self.propertyMappings valueForKey:key];
    if (!modelMapping)
        modelMapping = [DDDModelMapping new];
    
    modelMapping.mappingType    = DDDModelMappingTypeSingleModel;
    modelMapping.modelClass     = klass;
    [self.propertyMappings setValue:modelMapping forKey:key];
}

- (void)setArrayOfModelsWithClass:(Class)klass forKey:(NSString *)key
{
    DDDModelMapping *modelMapping = [self.propertyMappings valueForKey:key];
    if (!modelMapping)
        modelMapping = [DDDModelMapping new];
    
    modelMapping.mappingType    = DDDModelMappingTypeMultipleModel;
    modelMapping.modelClass     = klass;
    [self.propertyMappings setValue:modelMapping forKey:key];
}

- (void)setupPropertyMappingsWithDictionary:(NSDictionary *)dictionary
{
    // base implementation does nothing
}

- (BOOL)handleRemappingWithKey:(NSString *)key withPropertyDictionary:(NSDictionary *)dictionary
{
    NSString *remappedKey = remappings()[key];
    if (!remappedKey)
        return NO;
    else
        [self setValue:remappedKey forKey:[dictionary valueForKey:key]];
        return YES;
}

- (void)prepareWithAttributes:(NSDictionary *)dictionary
{
    [self setupPropertyMappingsWithDictionary:dictionary];
    
    for (NSString *key in dictionary)
    {
        if ([self handleRemappingWithKey:key withPropertyDictionary:dictionary])
            continue;
        id<DDDMapping> mapping = [self.propertyMappings valueForKey:key];
        if (mapping)
        {
            switch ([mapping mappingType]) {
                case DDDModelMappingTypeSingleModel:
                {
                    Class klass = [(DDDModelMapping *)mapping modelClass];
                    id model;
                    if ([klass instancesRespondToSelector:@selector(initWithDictionary:)])
                        model = [[klass alloc] initWithDictionary:[dictionary valueForKey:key]];
                    else
                        model = [klass new];
                    
                    [self setValue:model forKey:key];
                }
                case DDDModelMappingTypeMultipleModel:
                {
                    Class klass = [(DDDModelMapping *)mapping modelClass];
                    NSArray *rawElements = [dictionary valueForKey:key];
                    NSMutableArray *parsedElements = [NSMutableArray array];
                    
                    BOOL respondsToDictionary = ([klass instancesRespondToSelector:@selector(initWithDictionary:)]);
                    
                    for (NSDictionary *rawElement in rawElements)
                    {
                        id model = (respondsToDictionary) ? [[klass alloc] initWithDictionary:rawElement] : [klass new];
                        [parsedElements addObject:model];
                    }
                    [self setValue:parsedElements forKey:key];
                    
                }
                case DDDModelMappingTypeEnumerationType:
                {
                    NSDictionary *enumerationMapping = [(DDDEnumerationMapping *)mapping enumerationMapping];
                    [self setValue:[enumerationMapping valueForKey:key] forKey:key];
                }
            }
        }
        else
            [self setValue:[dictionary valueForKey:key] forKey:key];
    }
}

#pragma mark - Helpers
//
static NSDictionary *remappings()
{
    return @{
             @"id" : @"identifier"
             };
}


#pragma mark - KVC
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // do nothing
    DDLogWarn(@"Tried to set value: %@ for undefined key: %@ in class: %@", value, key, NSStringFromClass([self class]));
}

- (id)valueForUndefinedKey:(NSString *)key
{
    DDLogWarn(@"Tried to get value for undefined key: %@", key);
    return nil;
}
@end
