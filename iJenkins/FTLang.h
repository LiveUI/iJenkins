//
//  FTLang.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


#define FTLangGet(key) [FTLang get:key]


@interface FTLang : NSObject

+ (NSString *)get:(NSString *)key;


@end
