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
        [self setupPropertyMappingsWithDictionary:dictionary];
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

- (void)prepareWithAttributes:(NSDictionary *)dictionary
{
    [self setupPropertyMappingsWithDictionary:dictionary];
    
    for (NSString *key in dictionary)
    {
        id<DDDMapping> mapping = [self.propertyMappings valueForKey:key];
        if (mapping)
        {
            switch ([mapping mappingType]) {
                case DDDModelMappingTypeSingleModel:
                {
                    
                }
                case DDDModelMappingTypeMultipleModel:
                {
                    
                }
                case DDDModelMappingTypeEnumerationType:
                {
                    
                }
            }
        }
    }
}


#pragma mark - KVC
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // do nothing
    DDLogWarn(@"Tried to set value: %@ for undefined key: %@ in class: %@", value, key, NSStringFromClass([self class]));
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    id<DDDMapping> mapping = [self.propertyMappings valueForKey:key];
    if (mapping)
    {
        switch (mapping.mappingType) {
            case DDDModelMappingTypeEnumerationType:
            {
                
                break;
            }
            case DDDModelMappingTypeMultipleModel:
            {
                
                break;
            }
            case DDDModelMappingTypeSingleModel:
            {
                
                break;
            }
        }
    }
    else
        [super setValue:value forKey:key];
}
@end
