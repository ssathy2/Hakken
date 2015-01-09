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
        timeVal = timeDifferenceBetweenDates;
        timeFormat = (timeVal == 1) ? @"%i second ago" : @"%i seconds ago";
    }
    else if (timeDifferenceBetweenDates >= SECONDSINONEMINUTE && timeDifferenceBetweenDates < SECONDSINONEHOUR)
    {
        timeVal = (NSInteger)timeDifferenceBetweenDates/SECONDSINONEMINUTE;
        timeFormat = (timeVal == 1) ? @"%i minute ago" : @"%i minutes ago";
    }
    else if (timeDifferenceBetweenDates >= SECONDSINONEHOUR && timeDifferenceBetweenDates < SECONDSINONEDAY)
    {
        timeVal = (NSInteger)timeDifferenceBetweenDates/SECONDSINONEHOUR;
        timeFormat = (timeVal == 1) ? @"%i hour ago" : @"%i hours ago";
    }
    else
    {
        timeVal = (NSInteger)timeDifferenceBetweenDates/SECONDSINONEDAY;
        timeFormat = (timeVal == 1) ? @"%i day ago" : @"%i days ago";
    }
    
    return [NSString stringWithFormat:timeFormat, timeVal];
}
@end
