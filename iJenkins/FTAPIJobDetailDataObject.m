//
//  FTAPIJobDetailDataObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIJobDetailDataObject.h"


@interface FTAPIJobDetailDataObject ()

@property (nonatomic, strong) NSString *jobName;

@end


@implementation FTAPIJobDetailDataObject


#pragma mark Object implementation

- (FTHttpMethod)httpMethod {
    return FTHttpMethodGet;
}

- (NSString *)methodName {
    return [NSString stringWithFormat:@"job/%@/", _jobName];
}

- (NSDictionary *)payloadData {
    return nil;
}

- (void)processData:(NSDictionary *)data {
    [super processData:data];
    
    NSLog(@"Data: %@", data);
    
    _lastBuild = [[FTAPIJobDetailBuildDataObject alloc] init];
    [_lastBuild processData:[data objectForKey:@"lastBuild"]];
}

#pragma mark Initialization

- (id)initWithJobName:(NSString *)jobName {
    self = [super init];
    if (self) {
        _jobName = jobName;
    }
    return self;
}


@end


@implementation FTAPIJobDetailBuildDataObject

#pragma makr Data

- (void)processData:(NSDictionary *)data {
    _number = [[data objectForKey:@"number"] integerValue];
    _urlString = [data objectForKey:@"url"];
}


@end
