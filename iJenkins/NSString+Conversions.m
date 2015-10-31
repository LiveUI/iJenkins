//
//  NSString+Conversions.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 08/10/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "NSString+Conversions.h"


@implementation NSString (Conversions)


#pragma mark Filesize

+ (NSString *)formatFilesize:(double)bytes {
    double convertedValue = bytes;
    int multiplyFactor = 0;
    
    NSArray *tokens = @[@"bytes", @"KB", @"MB", @"GB", @"TB"];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}


@end
