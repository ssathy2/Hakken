//
//  DDDMock.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/20/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "DDDMock.h"

@implementation DDDMock
+ (NSDictionary *)dictionaryFromJSONFile:(NSString *)file
{
    if (file.length == 0)
        return nil;
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *fullFilePath = [bundle pathForResource:file ofType:@"json"];
    if (!fullFilePath)
        return nil;
    
    NSData *rawJSON = [[NSData alloc] initWithContentsOfFile:fullFilePath options:NSDataReadingMappedIfSafe error:nil];
    return (rawJSON) ? [NSJSONSerialization JSONObjectWithData:rawJSON options:0 error:nil] : nil;
}
@end
