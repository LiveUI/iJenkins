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
    _name = @"";
    _host = @"";
    _https = NO;
    _port = 8080;
    _xpath = YES;
    _timeout = 20;
    _overrideJenkinsUrl = YES;
    _loadMaxItems = 50;
    _buildLogMaxSize = 102400;
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
    }
    return _originalDictionary;
}

#pragma mark Setters

- (void)setName:(NSString *)name {
    _name = name;
    [_originalDictionary setValue:name forKey:@"name"];
}

- (void)setHost:(NSString *)host {
    _host = host;
    [_originalDictionary setValue:host forKey:@"host"];
}

- (void)setPathSuffix:(NSString *)pathSuffix {
    _pathSuffix = pathSuffix;
    [_originalDictionary setValue:pathSuffix forKey:@"pathSuffix"];
}

- (void)setHttps:(BOOL)https {
    _https = https;
    [_originalDictionary setValue:[NSNumber numberWithBool:https] forKey:@"https"];
}

- (void)setPort:(NSInteger)port {
    _port = port;
    [_originalDictionary setValue:[NSNumber numberWithInteger:port] forKey:@"port"];
}

- (void)setXpath:(BOOL)xpath {
    _xpath = xpath;
    [_originalDictionary setValue:[NSNumber numberWithBool:xpath] forKey:@"xpath"];
}

- (void)setTimeout:(NSTimeInterval)timeout {
    _timeout = timeout;
    [_originalDictionary setValue:[NSNumber numberWithDouble:timeout] forKey:@"timeout"];
}

- (void)setOverrideJenkinsUrl:(BOOL)overrideJenkinsUrl {
    _overrideJenkinsUrl = overrideJenkinsUrl;
    [_originalDictionary setValue:[NSNumber numberWithBool:overrideJenkinsUrl] forKey:@"overrideJenkinsUrl"];
}

- (void)setLoadMaxItems:(NSInteger)loadMaxItems {
    _loadMaxItems = loadMaxItems;
    [_originalDictionary setValue:[NSNumber numberWithInteger:loadMaxItems] forKey:@"loadMaxItems"];
}

- (void)setBuildLogMaxSize:(double)buildLogMaxSize {
    _buildLogMaxSize = buildLogMaxSize;
    [_originalDictionary setValue:[NSNumber numberWithDouble:buildLogMaxSize] forKey:@"buildLogMaxSize"];
}

- (void)setUsername:(NSString *)username {
    _username = username;
    [_originalDictionary setValue:username forKey:@"username"];
}

- (void)setPasswordOrToken:(NSString *)passwordOrToken {
    _passwordOrToken = passwordOrToken;
    [_originalDictionary setValue:passwordOrToken forKey:@"password"];
}

#pragma mark Getters

- (NSString *)baseUrl {
    NSString *url = [NSString stringWithFormat:@"http://%@:%d/", _host, _port];
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
