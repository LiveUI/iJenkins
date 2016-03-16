//
//  FTAccountsManager.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAccountsManager.h"
#import "FTKeychainObject.h"


static NSMutableArray *accounts = nil;
static NSMutableArray *demoAccounts = nil;
static FTAccountsManager *staticManager = nil;


@implementation FTAccountsManager


#pragma mark Object conversions

- (FTAccount *)accountFromDictionary:(NSDictionary *)dic {
    FTAccount *acc = [[FTAccount alloc] init];
    [acc setName:[dic valueForKey:@"name"]];
    [acc setHost:[dic valueForKey:@"host"]];
    [acc setPathSuffix:[dic valueForKey:@"pathSuffix"]];
    [acc setHttps:[[dic valueForKey:@"https"] boolValue]];
    [acc setPort:[[dic valueForKey:@"port"] integerValue]];
    [acc setXpath:[[dic valueForKey:@"xpath"] boolValue]];
    [acc setTimeout:[[dic valueForKey:@"timeout"] integerValue]];
    [acc setOverrideJenkinsUrl:[[dic valueForKey:@"overrideJenkinsUrl"] boolValue]];
    [acc setLoadMaxItems:[[dic valueForKey:@"loadMaxItems"] integerValue]];
    [acc setBuildLogMaxSize:[[dic valueForKey:@"buildLogMaxSize"] integerValue]];
    [acc setUsername:[dic valueForKey:@"username"]];
    [acc setPasswordOrToken:[dic valueForKey:@"password"]];
    return acc;
}

- (NSArray *)dataAccounts {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:accounts.count];
    for (FTAccount *acc in accounts) {
        [arr addObject:acc.originalDictionary];
    }
    return arr;
}

#pragma mark Data handling

- (void)saveToKeychainForAccountType:(FTAccountType)accountType {
    NSError *err;
    NSArray *ac = [self dataAccounts];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ac options:0 error:&err];
    if (err) {
        NSLog(@"Error writing: %@", err.localizedDescription);
    }
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
    [[FTKeychainObject sharedKeychainObject] setAccountsJsonFile:string forType:accountType];
}

}

- (void)updateAccount:(FTAccount *)account {
}

}

- (void)moveAccount:(FTAccount *)account toIndex:(NSInteger)newIndex {
    [accounts removeObject:account];
    [accounts insertObject:account atIndex:newIndex];
}

- (NSArray *)accounts {
    if (accounts) return accounts;
    else {
        NSString *jsonString = [[FTKeychainObject sharedKeychainObject] accountsJsonFileForType:FTAccountTypeKeychain];
        return [self accountsForJSON:jsonString withAccountType:FTAccountTypeKeychain];
    }
}

- (NSArray *)demoAccounts {
    if (demoAccounts) return demoAccounts;
    else {
        NSString *jsonString = [[FTKeychainObject sharedKeychainObject] accountsJsonFileForType:FTAccountTypeDemo];
        
        if (jsonString == nil) {
            [self createDemoAccounts];
            jsonString = [[FTKeychainObject sharedKeychainObject] accountsJsonFileForType:FTAccountTypeDemo];
        }
        
        return [self accountsForJSON:jsonString withAccountType:FTAccountTypeDemo];
    }
}

- (NSArray *)accountsForJSON:(NSString *)jsonString withAccountType:(FTAccountType)accountType {
    NSArray *dataAccounts = nil;
    if (jsonString) {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        dataAccounts = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&err];
        if (err) {
            NSLog(@"Error reading: %@", err.localizedDescription);
        }
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *d in dataAccounts) {
        FTAccount *a = [self accountFromDictionary:d];
        [a setAccountType:accountType];
        [arr addObject:a];
    }
    return arr;
}

- (void)createDemoAccounts {
    FTAccount *jenkins = [[FTAccount alloc] init];
    [jenkins setAccountType:FTAccountTypeDemo];
    [jenkins setName:FTLangGet(@"Jenkins builds")];
    [jenkins setHost:@"ci.jenkins-ci.org"];
    [jenkins setPort:443];
    [jenkins setUsername:nil];
    [jenkins setPasswordOrToken:nil];
    [jenkins setLoadMaxItems:8];
    [jenkins setTimeout:15];
    [jenkins setHttps:YES];
    
    
    FTAccount *apache = [[FTAccount alloc] init];
    [apache setAccountType:FTAccountTypeDemo];
    [apache setName:FTLangGet(@"Apache builds")];
    [apache setHost:@"builds.apache.org"];
    [apache setPort:80];
    [apache setUsername:nil];
    [apache setPasswordOrToken:nil];
    [apache setLoadMaxItems:8];
    [apache setTimeout:20];
}

#pragma mark Initialization

+ (FTAccountsManager *)sharedManager {
    if (staticManager) return staticManager;
    else {
        return [[FTAccountsManager alloc] init];
    }
}

- (id)init {
    if (staticManager) return staticManager;
    self = [super init];
    if (self) {
        staticManager = self;
        [self accounts];
    }
    return self;
}


@end
