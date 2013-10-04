//
//  NSDate+Formatting.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 04/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "NSDate+Formatting.h"


@implementation NSDate (Formatting)


- (NSString *)relativeDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self toDate:[NSDate date] options:0];
    
    NSArray *selectorNames = [NSArray arrayWithObjects:@"year", @"month", @"week", @"day", @"hour", @"minute", @"second", nil];
    
    for (NSString *selectorName in selectorNames) {
        SEL currentSelector = NSSelectorFromString(selectorName);
        NSMethodSignature *currentSignature = [NSDateComponents instanceMethodSignatureForSelector:currentSelector];
        NSInvocation *currentInvocation = [NSInvocation invocationWithMethodSignature:currentSignature];
        
        [currentInvocation setTarget:components];
        [currentInvocation setSelector:currentSelector];
        [currentInvocation invoke];
        
        NSInteger relativeNumber;
        [currentInvocation getReturnValue:&relativeNumber];
        
        if (relativeNumber && relativeNumber != INT32_MAX) {
            if (relativeNumber > 1) {
                return [NSString stringWithFormat:@"%d %@s ago", relativeNumber, FTLangGet(selectorName)];
            }
            else {
                return [NSString stringWithFormat:@"%d %@ ago", relativeNumber, FTLangGet(selectorName)];
            }
        }
    }
    
    return FTLangGet(@"now");
}


@end
