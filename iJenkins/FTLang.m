//
//  FTLang.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTLang.h"
#if TARGET_OS_IOS || (TARGET_OS_IPHONE && !TARGET_OS_TV)
#import <LUIFramework/LUIFramework.h>
#endif

@implementation FTLang

+ (NSString *)get:(NSString *)key {
#if TARGET_OS_IOS || (TARGET_OS_IPHONE && !TARGET_OS_TV)
    return LUITranslate(key);
#else
    return key;
#endif
}


@end
