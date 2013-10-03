//
//  FTAccount.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAccount.h"


@interface FTAccount ()

@property (nonatomic) BOOL didCheckOnline;

@end


@implementation FTAccount


#pragma mark Data handling

- (void)setDefaultValues {
    _https = NO;
    _port = 8080;
    _xpath = YES;
    _timeout = 20;
    _overrideJenkinsUrl = YES;
    _loadMaxItems = 5;
    _buildLogMaxSize = 102400;
    _host = @"";
    _name = @"";
    _username = @"";
    _passwordOrToken = @"";
    _pathSuffix = @"";
    [self originalDictionary];
}

- (NSMutableDictionary *)originalDictionary {
    if (!_originalDictionary) {
        _originalDictionary = [NSMutableDictionary dictionary];
        [_originalDictionary setValue:[NSNumber numberWithBool:_https] forKey:@"https"];
        [_originalDictionary setValue:[NSNumber numberWithInteger:_port] forKey:@"port"];
        [_originalDictionary setValue:[NSNumber numberWithBool:_xpath] forKey:@"xpath"];
        [_originalDictionary setValue:[NSNumber numberWithDouble:_timeout] forKey:@"timeout"];
        [_originalDictionary setValue:[NSNumber numberWithBool:_overrideJenkinsUrl] forKey:@"overrideJenkinsUrl"];
        [_originalDictionary setValue:[NSNumber numberWithInteger:_loadMaxItems] forKey:@"loadMaxItems"];
        [_originalDictionary setValue:[NSNumber numberWithDouble:_buildLogMaxSize] forKey:@"buildLogMaxSize"];
        
        // Add blank strings to dictionary to allow revert back
        [_originalDictionary setValue:_host forKey:@"host"];
        [_originalDictionary setObject:_name forKey:@"name"];
        [_originalDictionary setObject:_username forKey:@"username"];
        [_originalDictionary setObject:_passwordOrToken forKey:@"password"];
        [_originalDictionary setObject:_pathSuffix forKey:@"pathSuffix"];
    }
    return _originalDictionary;
}

#pragma mark Setters

- (void)setName:(NSString *)name {
    _name = name;
    [self.originalDictionary setValue:name forKey:@"name"];
}

- (void)setHost:(NSString *)host {
    _host = host;
    [self.originalDictionary setValue:host forKey:@"host"];
}

- (void)setPathSuffix:(NSString *)pathSuffix {
    _pathSuffix = pathSuffix;
    [self.originalDictionary setValue:pathSuffix forKey:@"pathSuffix"];
}

- (void)setHttps:(BOOL)https {
    _https = https;
    [self.originalDictionary setValue:[NSNumber numberWithBool:https] forKey:@"https"];
}

- (void)setPort:(NSInteger)port {
    _port = port;
    [self.originalDictionary setValue:[NSNumber numberWithInteger:port] forKey:@"port"];
}

- (void)setXpath:(BOOL)xpath {
    _xpath = xpath;
    [self.originalDictionary setValue:[NSNumber numberWithBool:xpath] forKey:@"xpath"];
}

- (void)setTimeout:(NSTimeInterval)timeout {
    _timeout = timeout;
    [self.originalDictionary setValue:[NSNumber numberWithDouble:timeout] forKey:@"timeout"];
}

- (void)setOverrideJenkinsUrl:(BOOL)overrideJenkinsUrl {
    _overrideJenkinsUrl = overrideJenkinsUrl;
    [self.originalDictionary setValue:[NSNumber numberWithBool:overrideJenkinsUrl] forKey:@"overrideJenkinsUrl"];
}

- (void)setLoadMaxItems:(NSInteger)loadMaxItems {
    _loadMaxItems = loadMaxItems;
    [self.originalDictionary setValue:[NSNumber numberWithInteger:loadMaxItems] forKey:@"loadMaxItems"];
}

- (void)setBuildLogMaxSize:(double)buildLogMaxSize {
    _buildLogMaxSize = buildLogMaxSize;
    [self.originalDictionary setValue:[NSNumber numberWithInteger:buildLogMaxSize] forKey:@"buildLogMaxSize"];
}

- (void)setUsername:(NSString *)username {
    _username = username;
    [self.originalDictionary setValue:username forKey:@"username"];
}

- (void)setPasswordOrToken:(NSString *)passwordOrToken {
    _passwordOrToken = passwordOrToken;
    [self.originalDictionary setValue:passwordOrToken forKey:@"password"];
}

- (void)setOverridingDictionary:(NSMutableDictionary *)overridingDictionary {
    // Enumerate each key to reset the Account back to it was before
    [overridingDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isEqual:@"name"])              [self setName:obj];
        if ([key isEqual:@"host"])              [self setHost:obj];
        if ([key isEqual:@"pathSuffix"])        [self setPathSuffix:obj];
        if ([key isEqual:@"https"])             [self setHttps:[obj boolValue]];
        if ([key isEqual:@"port"])              [self setPort:[obj integerValue]];
        if ([key isEqual:@"xpath"])             [self setXpath:[obj boolValue]];
        if ([key isEqual:@"timeout"])           [self setTimeout:[obj doubleValue]];
        if ([key isEqual:@"overrideJenkinsUrl"])[self setOverrideJenkinsUrl:[obj boolValue]];
        if ([key isEqual:@"buildLogMaxSize"])   [self setBuildLogMaxSize:[obj doubleValue]];
        if ([key isEqual:@"username"])          [self setUsername:obj];
        if ([key isEqual:@"password"])          [self setPasswordOrToken:obj];
    }];
}

#pragma mark Getters

- (NSString *)hostUrl {
    NSString *port = (_port != 0) ? [NSString stringWithFormat:@":%d", _port] : @"";
    NSString *url = [NSString stringWithFormat:@"%@%@", _host, port];
    return url;
}

- (NSString *)baseUrl {
    NSString *https = _https ? @"s" : @"";
    NSString *url = [NSString stringWithFormat:@"http%@://%@/", https, self.hostUrl];
    return url;
}

#pragma mark Online checks

- (BOOL)isOnline {
    return _isOnline;
}

#pragma mark Initialization

- (id)init {
    self = [super init];
    if (self) {
        [self setDefaultValues];
    }
    return self;
}


@end
