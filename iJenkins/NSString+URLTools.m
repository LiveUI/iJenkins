//
//  NSString+URLTools.m
//  Cronycle
//
//  Created by Ondrej Rafaj on 16/08/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "NSString+URLTools.h"


@implementation NSString (URLTools)

+ (NSString *)serializeParams:(NSDictionary *)params {
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [params keyEnumerator]) {
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            for (NSString *subKey in value) {
                NSString *escaped = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[value objectForKey:subKey], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
                [pairs addObject:[NSString stringWithFormat:@"%@[%@]=%@", key, subKey, escaped]];
            }
        }
        else if ([value isKindOfClass:[NSArray class]]) {
            for (NSString *subValue in value) {
                NSString *escaped = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)subValue, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
                [pairs addObject:[NSString stringWithFormat:@"%@[]=%@", key, escaped]];
            }
        }
        else {
            NSString *escaped = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[params objectForKey:key], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped]];
        }
    }
    return [pairs componentsJoinedByString:@"&"];
}


@end
