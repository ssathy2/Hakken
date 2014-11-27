//
//  DDDResponseSerializer.h
//  Hakken
//
//  Created by Sidd Sathyam on 11/22/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDHackernewsItemResponseSerializer : NSObject

+ (NSArray *)arrayOfCommentsFromJSON:(NSDictionary *)json;
+ (NSArray *)arrayOfItemsFromJSONArray:(NSArray *)jsonArray;
@end
