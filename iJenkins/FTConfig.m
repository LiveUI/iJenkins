//
//  FTConfig.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTConfig.h"
#import "FTKeychainObject.h"


@implementation FTConfig


#pragma mark UUID

+ (NSString *)getNewUUID {
    NSString *result = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    assert(uuidStr != NULL);
    result = [(__bridge NSString *)uuidStr copy];
    CFRelease(uuidStr);
    return result;
}

+ (NSString *)getAppUUID {
    NSString *uuid = [FTKeychainObject sharedKeychainObject].uuid;
    if (!uuid || [uuid length] < 5) {
        uuid = [self getNewUUID];
        [[FTKeychainObject sharedKeychainObject] setUuid:uuid];
    }
    return uuid;
}


@end
