//
//  FTKeychainObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 13/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTKeychainObject.h"
#import <Security/Security.h>


#define kFTKeychainObjectAccountsJsonFile                           @"FTKeychainObjectTwitterToken"
#define kFTKeychainObjectUUID                                       @"FTKeychainObjectUUID"


#define kFTKeychainObjectServiceName                            @"com.fuerteint.ijenkins"

#define kFTKeychainObjectDebug                                  NO
#define kFTKeychainObjectDebugFull                              if (kFTKeychainObjectDebug)

@implementation FTKeychainObject


#pragma mark Keychain code

static NSString *serviceName = kFTKeychainObjectServiceName;

- (NSMutableDictionary *)newSearchDictionaryWithIdentifier:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    return searchDictionary;
}

- (NSString *)searchKeychainCopyMatchingIdentifier:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [self newSearchDictionaryWithIdentifier:identifier];
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    CFDataRef cfresult = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, (CFTypeRef *)&cfresult);
    NSString *result = [[NSString alloc] initWithData:(__bridge_transfer NSData *)cfresult encoding:NSUTF8StringEncoding];
    return ([result length] > 5) ? result : nil;
}

- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    NSMutableDictionary *dictionary = [self newSearchDictionaryWithIdentifier:identifier];
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

- (BOOL)updateKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [self newSearchDictionaryWithIdentifier:identifier];
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [updateDictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)searchDictionary, (__bridge CFDictionaryRef)updateDictionary);
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

- (void)deleteKeychainValue:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [self newSearchDictionaryWithIdentifier:identifier];
    SecItemDelete((__bridge CFDictionaryRef)searchDictionary);
}

#pragma mark Initialization

+ (FTKeychainObject *)sharedKeychainObject {
    return [[FTKeychainObject alloc] init];
}

#pragma mark Settings

- (NSString *)accountsJsonFile {
    NSString *s = [self searchKeychainCopyMatchingIdentifier:kFTKeychainObjectAccountsJsonFile];
    kFTKeychainObjectDebugFull NSLog(@"Accounts back: %@", s);
    return s;
}

- (void)setAccountsJsonFile:(NSString *)accountsJsonFile {
    BOOL ok;
    if (self.accountsJsonFile) {
        ok = [self updateKeychainValue:accountsJsonFile forIdentifier:kFTKeychainObjectAccountsJsonFile];
    }
    else {
        ok = [self createKeychainValue:accountsJsonFile forIdentifier:kFTKeychainObjectAccountsJsonFile];
    }
    kFTKeychainObjectDebugFull NSLog(@"Did save accounts to keychain: %@", ok ? @"Yes" : @"No");
}

- (NSString *)uuid {
    NSString *uuid = [self searchKeychainCopyMatchingIdentifier:kFTKeychainObjectUUID];
    kFTKeychainObjectDebugFull NSLog(@"UUID back: %@", uuid);
    return uuid;
}

- (void)setUuid:(NSString *)uuid {
    BOOL ok;
    if (self.uuid) {
        ok = [self updateKeychainValue:uuid forIdentifier:kFTKeychainObjectUUID];
    }
    else {
        ok = [self createKeychainValue:uuid forIdentifier:kFTKeychainObjectUUID];
    }
    kFTKeychainObjectDebugFull NSLog(@"Did save UUID to keychain: %@", ok ? @"Yes" : @"No");
}

- (void)logout {
    [self deleteKeychainValue:kFTKeychainObjectAccountsJsonFile];
}


@end