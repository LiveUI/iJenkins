//
//  FTAccountsManager.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAccountsManager.h"
#import "Lockbox.h"


#define kFTAccountsManagerAccountsKey                                   @"FTAccountsManagerAccountsKey"


static NSMutableArray *accounts = nil;
static NSMutableArray *dataAccounts = nil;
static FTAccountsManager *staticManager = nil;


@implementation FTAccountsManager


#pragma mark Object conversions

- (FTAccount *)accountFromDictionary:(NSDictionary *)dic {
    FTAccount *acc = [[FTAccount alloc] init];
    [acc setOriginalDictionary:[NSMutableDictionary dictionaryWithDictionary:dic]];
    [acc setName:[dic valueForKey:@"name"]];
    [acc setHost:[dic valueForKey:@"host"]];
    [acc setPathSuffix:[dic valueForKey:@"pathSuffix"]];
    [acc setHttps:[[dic valueForKey:@"https"] boolValue]];
    [acc setPort:[[dic valueForKey:@"port"] integerValue]];
    [acc setXpath:[[dic valueForKey:@"xpath"] boolValue]];
    [acc setTimeout:[[dic valueForKey:@"timeout"] integerValue]];
    [acc setOverrideJenkinsUrl:[[dic valueForKey:@"overrideJenkinsUrl"] boolValue]];
    [acc setLoadMaxItems:[[dic valueForKey:@"loadMaxItems"] integerValue]];
    [acc setBuildLogMaxSize:[[dic valueForKey:@"buildLogMaxSize"] doubleValue]];
    [acc setUsername:[dic valueForKey:@"username"]];
    [acc setPassword:[dic valueForKey:@"password"]];
    [acc setToken:[dic valueForKey:@"token"]];
    return acc;
}

- (NSMutableArray *)accountsDataToObjects {
    if (accounts) return accounts;
    dataAccounts = [NSMutableArray arrayWithArray:[Lockbox arrayForKey:kFTAccountsManagerAccountsKey]];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *d in dataAccounts) {
        FTAccount *a = [self accountFromDictionary:d];
        [arr addObject:a];
    }
    accounts = arr;
    return arr;
}

#pragma mark Data handling

- (void)saveToKeychain {
    [Lockbox setArray:dataAccounts forKey:kFTAccountsManagerAccountsKey];
}

- (void)addAccount:(FTAccount *)account {
    [accounts addObject:accounts];
    [dataAccounts addObject:account.originalDictionary];
    [self saveToKeychain];
}

- (void)removeAccount:(FTAccount *)account {
    [accounts removeObject:account];
    [dataAccounts removeObject:account.originalDictionary];
    [self saveToKeychain];
}

- (void)moveAccount:(FTAccount *)account toIndex:(NSInteger)newIndex {
    [accounts removeObject:accounts];
    [dataAccounts removeObject:account.originalDictionary];
    [accounts insertObject:account atIndex:newIndex];
    [dataAccounts insertObject:account.originalDictionary atIndex:newIndex];
    [self saveToKeychain];
}

- (NSArray *)accounts {
    return [self accountsDataToObjects];
}

- (void)createDemoAccount {
    FTAccount *acc = [[FTAccount alloc] init];
    [acc setName:FTLangGet(@"Demo account")];
    [acc setHost:@"fuerteint.com"];
    [acc setPort:8800];
    [acc setUsername:@"rafiki270"];
    [acc setPassword:@"exploited"];
    [self addAccount:acc];
}

#pragma mark Initialization

+ (id)sharedManager {
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
        if (!accounts || accounts.count == 0) {
            [self createDemoAccount];
        }
    }
    return self;
}


@end
