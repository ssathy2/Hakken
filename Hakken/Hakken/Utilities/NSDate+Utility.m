//
//  NSDate+Utility.m
//  Hakken
//
//  Created by Sidd Sathyam on 11/26/14.
//  Copyright (c) 2014 dotdotdot. All rights reserved.
//

#import "NSDate+Utility.h"

#define SECONDSINONEMINUTE 60
#define SECONDSINONEHOUR   (SECONDSINONEMINUTE*60)
#define SECONDSINONEDAY    (SECONDSINONEHOUR*24)

@implementation NSDate (Utility)
- (NSString *)relativeDateTimeStringToNow
{
    NSTimeInterval timeDifferenceBetweenDates = [[NSDate date] timeIntervalSinceDate:self];
    NSString *timeFormat;
    NSInteger timeVal = 0;
    if (timeDifferenceBetweenDates >= 0 && timeDifferenceBetweenDates < SECONDSINONEMINUTE)
    {
        timeFormat = @"%i seconds ago";
        timeVal = timeDifferenceBetweenDates;
    }
    else if (timeDifferenceBetweenDates >= SECONDSINONEMINUTE && timeDifferenceBetweenDates < SECONDSINONEHOUR)
    {
        timeFormat = @"%i minutes ago";
        timeVal = (NSInteger)timeDifferenceBetweenDates/SECONDSINONEMINUTE;
    }
    else if (timeDifferenceBetweenDates >= SECONDSINONEHOUR && timeDifferenceBetweenDates < SECONDSINONEDAY)
    {
        timeFormat = @"%i hours ago";
        timeVal = (NSInteger)timeDifferenceBetweenDates/SECONDSINONEHOUR;
    }
    else
        return @"A while ago";
    
    return [NSString stringWithFormat:timeFormat, timeVal];
}
@end
