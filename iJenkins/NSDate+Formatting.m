//
//  NSDate+Formatting.m
//
//  Created by Ondrej Rafaj on 04/10/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "NSDate+Formatting.h"


@implementation NSDate (Formatting)


- (NSString *)relativeDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
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
                return [NSString stringWithFormat:@"%ld %@s %@", (long)relativeNumber, FTLangGet(selectorName), FTLangGet(@"ago")];
            }
            else {
                return [NSString stringWithFormat:@"%ld %@ %@", (long)relativeNumber, FTLangGet(selectorName), FTLangGet(@"ago")];
            }
        }
    }
    
    return FTLangGet(@"now");
}


@end
