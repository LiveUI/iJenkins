//
//  UIColor+Jenkins.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 04/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "UIColor+Jenkins.h"


@implementation UIColor (Jenkins)


+ (UIColor *)colorForJenkinsColorCode:(NSString *)colorCode {
    if ([colorCode isEqualToString:@"red"]) {
        return [UIColor colorWithHexString:@"FF4000"];
    }
    else if ([colorCode isEqualToString:@"blue"]) {
        return [UIColor colorWithHexString:@"007EF3"]; // Green: 6DD900
    }
    else if ([colorCode isEqualToString:@"yellow"]) {
        return [UIColor colorWithHexString:@"FFDC73"];
    }
    else if ([colorCode isEqualToString:@"aborted"]) {
        return [UIColor grayColor];
    }
    else if ([colorCode isEqualToString:@"disabled"]) {
        return [UIColor darkGrayColor];
    }
    else if ([colorCode isEqualToString:@"notbuilt"]) {
        return [UIColor lightGrayColor];
    }
    else  {
        return [UIColor clearColor];
    }
}

+ (UIColor *)colorForJenkinsBuildStatus:(NSString *)buildStatus {
    if (!buildStatus || [buildStatus isKindOfClass:[NSNull class]]) {
        return [UIColor colorWithWhite:0 alpha:0.1];
    }
    if ([buildStatus isEqualToString:@"SUCCESS"]) {
        return [UIColor colorWithHexString:@"007EF3"]; // Green: 6DD900
    }
    else if ([buildStatus isEqualToString:@"UNSTABLE"]) {
        return [UIColor colorWithHexString:@"FFDC73"];
    }
    else if ([buildStatus isEqualToString:@"FAILURE"]) {
        return [UIColor colorWithHexString:@"FF4000"];
    }
    else if ([buildStatus isEqualToString:@"ABORTED"]) {
        return [UIColor grayColor];
    }
    else {
        return [UIColor colorWithWhite:0 alpha:0.1];
    }
}


@end
