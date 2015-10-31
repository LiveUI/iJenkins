//
//  FTAPIUserDetailDataObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 08/10/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTAPIUserDetailDataObject.h"


@implementation FTAPIUserDetailDataObject

#pragma mark - Object implementation

- (FTHttpMethod)httpMethod {
    if (_action == FTAPIUserDetailDataObjectActionFetch) {
        return FTHttpMethodGet;
    }
    else {
        return FTHttpMethodPost;
    }
}

- (NSString *)methodName {
    if (_action == FTAPIUserDetailDataObjectActionFetch) {
        return [NSString stringWithFormat:@"user/%@/", _nickName];
    }
    else {
        return [NSString stringWithFormat:@"user/%@/doDelete", _nickName];
    }
}

- (NSDictionary *)payloadData {
    if (_action == FTAPIUserDetailDataObjectActionFetch) {
        return nil;
    }
    else {
        return @{@"json": @"init"};
    }
}

- (id)valueForProperty:(NSString *)propertyKey {
    for (NSDictionary *d in _property) {
        if (d[propertyKey]) {
            return d[propertyKey];
        }
    }
    return nil;
}

- (void)processData:(NSDictionary *)data {
    [super processData:data];
    
    if (_action == FTAPIUserDetailDataObjectActionFetch) {
        _absoluteUrl = data[@"absoluteUrl"];
        _userDescription = data[@"description"];
        _fullName = data[@"fullName"];
        _nickName = data[@"id"];
        _property = data[@"property"];
        _insensitiveSearch = [[self valueForProperty:@"insensitiveSearch"] boolValue];
        _emailAddress = [self valueForProperty:@"address"];
    }
}

- (void)processHeaders:(NSDictionary *)headers {
    [super processHeaders:headers];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityHigh;
}

- (NSString *)suffix {
    if (_action == FTAPIUserDetailDataObjectActionFetch) {
        return [super suffix];
    }
    else {
        return @"";
    }
}

- (NSInteger)depth {
    return 1;
}

#pragma mark Initialization

- (id)initWithNickName:(NSString *)nickName {
    self = [super init];
    if (self) {
        _nickName = nickName;
    }
    return self;
}


@end
