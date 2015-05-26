//
//  FTLang.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTLang.h"
#import <LUIFramework/LUIFramework.h>


@implementation FTLang

+ (NSString *)get:(NSString *)key {
    return LUITranslate(key);
}


@end
