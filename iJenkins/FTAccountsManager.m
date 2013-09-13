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
static FTAccountsManager *staticManager = nil;


@implementation FTAccountsManager


#pragma mark Paths

- (NSString *)accountsFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"accounts.plist"];
}

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
    [acc setBuildLogMaxSize:[[dic valueForKey:@"buildLogMaxSize"] doubleValue]];
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

- (void)saveToKeychain {
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self dataAccounts] options:NSJSONWritingPrettyPrinted error:&err];
    if (err) {
        NSLog(@"Error writing: %@", err.localizedDescription);
    }
    NSString *string = [NSString stringWithCString:jsonData.bytes encoding:NSUTF8StringEncoding];
    [[FTKeychainObject sharedKeychainObject] setAccountsJsonFile:string];
//    [[self dataAccounts] writeToFile:[self accountsFilePath] atomically:YES];
}

- (void)addAccount:(FTAccount *)account {
    [accounts addObject:account];
    [self saveToKeychain];
}

- (void)updateAccount:(FTAccount *)account {
    [self saveToKeychain];
}

- (void)removeAccount:(FTAccount *)account {
    [accounts removeObject:account];
    [self saveToKeychain];
}

- (void)moveAccount:(FTAccount *)account toIndex:(NSInteger)newIndex {
    [accounts removeObject:accounts];
    [accounts insertObject:account atIndex:newIndex];
    [self saveToKeychain];
}

- (NSArray *)accounts {
    if (accounts) return accounts;
    else {
        NSString *jsonString = [[FTKeychainObject sharedKeychainObject] accountsJsonFile];
        NSLog(@"Json string :%@", jsonString);
        
        
        NSArray *dataAccounts = nil;
        if (jsonString) {
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            dataAccounts = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&err];
            if (err) {
                NSLog(@"Error reading: %@", err.localizedDescription);
            }
        }
//        NSArray *dataAccounts = [NSArray arrayWithContentsOfFile:[self accountsFilePath]];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *d in dataAccounts) {
            FTAccount *a = [self accountFromDictionary:d];
            [arr addObject:a];
        }
        accounts = arr;
        return arr;
    }
}

- (FTAccount *)demoAccount {
    FTAccount *acc = [[FTAccount alloc] init];
    [acc setName:FTLangGet(@"Apache builds")];
    [acc setHost:@"builds.apache.org"];
    [acc setPort:80];
    [acc setUsername:nil];
    [acc setPasswordOrToken:nil];
    return acc;
}

- (void)createDemoAccount {
    [self addAccount:[self demoAccount]];
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
