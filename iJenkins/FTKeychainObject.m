//
//  FTKeychainObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 13/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTKeychainObject.h"
#import <Security/Security.h>


#define dFTKeychainObjectAccountsJsonFile                           @"FTKeychainObjectAccountsToken"
#define dFTKeychainObjectDemoAccountsJsonFile                       @"FTKeychainObjectDemoAccountsToken"

#define dFTKeychainObjectUUID                                       @"FTKeychainObjectUUID"


#define dFTKeychainObjectServiceName                                @"com.fuerteint.ijenkins"

#define dFTKeychainObjectDebug                                      NO
#define dFTKeychainObjectDebugFull                                  if (dFTKeychainObjectDebug)

@implementation FTKeychainObject


#pragma mark Keychain code

static NSString *serviceName = dFTKeychainObjectServiceName;

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
    [dictionary setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    if (status == errSecSuccess) {
        return YES;
    }
    if (status == errSecDuplicateItem){
        //If a duplicate found on a create, it should remove the previous one.
        [self deleteKeychainValue:identifier];
        //Recursive call ensures the keychain is definitely NOT a DUPLICATE on CREATE. (because it should be new)
        [self createKeychainValue:password forIdentifier:identifier];
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
    static FTKeychainObject *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[FTKeychainObject alloc] init];
    });
    return shared;
}

#pragma mark - Settings


- (NSString *)accountsJsonFileForType:(FTAccountType)accountType {
    switch (accountType) {
        case FTAccountTypeKeychain:
            [self userAccountsJsonFile];
            break;
        case FTAccountTypeDemo:
            [self demoAccountsJsonFile];
            break;
        default:
            // Do nothing for Bonjour / Network Accounts
            break;
    }
    return nil;
}

- (void)setAccountsJsonFile:(NSString *)jsonFile forType:(FTAccountType)accountType {
    switch (accountType) {
        case FTAccountTypeKeychain:
            [self setUserAccountsJsonFile:jsonFile];
            break;
        case FTAccountTypeDemo:
            [self setDemoAccountsJsonFile:jsonFile];
            break;
        default:
            
            // Do nothing for Bonjour/Network Accounts
            break;
    }
}

#pragma mark Accounts
- (NSString *)userAccountsJsonFile {
    NSString *s = [self searchKeychainCopyMatchingIdentifier:dFTKeychainObjectAccountsJsonFile];
    dFTKeychainObjectDebugFull NSLog(@"Accounts back: %@", s);
    return s;
}

- (void)setUserAccountsJsonFile:(NSString *)accountsJsonFile {
    BOOL ok;
    if (self.userAccountsJsonFile) {
        ok = [self updateKeychainValue:accountsJsonFile forIdentifier:dFTKeychainObjectAccountsJsonFile];
    }
    else {
        ok = [self createKeychainValue:accountsJsonFile forIdentifier:dFTKeychainObjectAccountsJsonFile];
    }
    dFTKeychainObjectDebugFull NSLog(@"Did save accounts to keychain: %@", ok ? @"Yes" : @"No");
}

#pragma mark Demo Accounts

- (NSString *)demoAccountsJsonFile {
    NSString *jsonFile = [self searchKeychainCopyMatchingIdentifier:dFTKeychainObjectDemoAccountsJsonFile];
    dFTKeychainObjectDebugFull NSLog(@"Demo Accounts : %@", jsonFile);
    return jsonFile;
}

- (void)setDemoAccountsJsonFile:(NSString *)accountsJsonFile {
    BOOL ok;
    if (self.demoAccountsJsonFile) {
        ok = [self updateKeychainValue:accountsJsonFile forIdentifier:dFTKeychainObjectAccountsJsonFile];
    }
    else {
        ok = [self createKeychainValue:accountsJsonFile forIdentifier:dFTKeychainObjectAccountsJsonFile];
    }
    dFTKeychainObjectDebugFull NSLog(@"Did save accounts to keychain: %@", ok ? @"Yes" : @"No");
}


#pragma mark Other

- (NSString *)uuid {
    NSString *uuid = [self searchKeychainCopyMatchingIdentifier:dFTKeychainObjectUUID];
    dFTKeychainObjectDebugFull NSLog(@"UUID back: %@", uuid);
    return uuid;
}

- (void)setUuid:(NSString *)uuid {
    BOOL ok;
    if (self.uuid) {
        ok = [self updateKeychainValue:uuid forIdentifier:dFTKeychainObjectUUID];
    }
    else {
        ok = [self createKeychainValue:uuid forIdentifier:dFTKeychainObjectUUID];
    }
    dFTKeychainObjectDebugFull NSLog(@"Did save UUID to keychain: %@", ok ? @"Yes" : @"No");
}

- (void)logout {
    [self deleteKeychainValue:dFTKeychainObjectAccountsJsonFile];
}


@end