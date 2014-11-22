//
//  NSObject+Introspection.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/22/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "NSObject+Introspection.h"
@import ObjectiveC;

@implementation NSObject (Introspection)
+ (NSArray *)propertyNames
{
    NSMutableArray *propertyNames = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(self, &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *propertyName = [NSString stringWithCString:propName
                                                        encoding:[NSString defaultCStringEncoding]];
            [propertyNames addObject:propertyName];
        }
    }
    free(properties);
    return propertyNames;
}
@end
