//
//  FTTheme.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 01/11/2015.
//  Copyright © 2015 Ridiculous Innovations. All rights reserved.
//

#import "FTTheme.h"
#import "FTThemeiOS.h"
#import "FTThemetvOS.h"


@implementation FTTheme


#pragma mark Initialization

+ (id <FTThemeProtocol>)sharedTheme {
    static id <FTThemeProtocol> sharedTheme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTheme = [self buidTheme];
    });
    
    return sharedTheme;
}

+ (id <FTThemeProtocol>)buidTheme {
#if TARGET_OS_IOS || (TARGET_OS_IPHONE && !TARGET_OS_TV)
    return [[FTThemeiOS alloc] init];
#elif TARGET_OS_TV
    return [[FTThemetvOS alloc] init];
#endif
}


@end
