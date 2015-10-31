//
//  FTAPIUsersDataObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 08/10/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTAPIUsersDataObject.h"


@implementation FTAPIUsersDataObject

#pragma mark - Object implementation

- (FTHttpMethod)httpMethod {
    return FTHttpMethodGet;
}

- (NSString *)methodName {
    return @"people/";
}

- (NSDictionary *)payloadData {
    return nil;
}

- (void)processData:(NSDictionary *)data {
    [super processData:data];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *d in data[@"users"]) {
        FTAPIUsersInfoDataObject *user = [[FTAPIUsersInfoDataObject alloc] init];
        [user processData:d];
        [arr addObject:user];
    }
    _users = [arr copy];
}

- (void)processHeaders:(NSDictionary *)headers {
    [super processHeaders:headers];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityHigh;
}

- (NSInteger)depth {
    return 1;
}


@end


@implementation FTAPIUsersInfoDataObject


#pragma mark Processing data

- (void)processData:(NSDictionary *)data {
    _fullName = data[@"user"][@"fullName"];
    
    _absoluteUrl = data[@"user"][@"absoluteUrl"];
    if (data[@"lastChange"] && ![data[@"lastChange"] isKindOfClass:[NSNull class]]) {
        _lastChange = [data[@"lastChange"] doubleValue];
    }
    
    NSArray *arr = [_absoluteUrl componentsSeparatedByString:@"/"];
    _nickName = [arr lastObject];
    
    if (data[@"project"] && ![data[@"project"] isKindOfClass:[NSNull class]]) {
        _project = [[FTAPIJobDataObject alloc] init];
        [_project processData:data[@"project"]];
    }
}



@end
