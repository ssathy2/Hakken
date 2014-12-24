//
//  DDDModel.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/17/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

//TODO: Move the nscoding method to a DDDObject subclass
@interface DDDModel : NSObject<NSCoding>
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

// Hook to setup mappings with a dictionary
- (void)setupPropertyMappingsWithDictionary:(NSDictionary *)dictionary;

- (void)setEnumerationMapping:(NSDictionary *)enumerationMapping forKey:(NSString *)key;
- (void)setModelClass:(Class)klass forKey:(NSString *)key;
- (void)setArrayOfModelsWithClass:(Class)klass forKey:(NSString *)key;
@end
