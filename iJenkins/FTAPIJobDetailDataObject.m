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
    
    //NSLog(@"Data: %@", data);
    
    _displayName = [data objectForKey:@"displayName"];
    _name = [data objectForKey:@"name"];
    _url = [data objectForKey:@"url"];
    _description = [data objectForKey:@"description"];
    _buildable = [[data objectForKey:@"buildable"] boolValue];
    
    _lastBuild = [[FTAPIJobDetailBuildDataObject alloc] init];
    [_lastBuild processData:[data objectForKey:@"lastBuild"]];
    
    _lastFailedBuild = [[FTAPIJobDetailBuildDataObject alloc] init];
    [_lastFailedBuild processData:[data objectForKey:@"lastFailedBuild"]];
    
    _lastSuccessfulBuild = [[FTAPIJobDetailBuildDataObject alloc] init];
    [_lastSuccessfulBuild processData:[data objectForKey:@"lastSuccessfulBuild"]];
    
    _lastUnstableBuild = [[FTAPIJobDetailBuildDataObject alloc] init];
    [_lastUnstableBuild processData:[data objectForKey:@"lastUnstableBuild"]];
    
    _lastUnsuccessfulBuild = [[FTAPIJobDetailBuildDataObject alloc] init];
    [_lastUnsuccessfulBuild processData:[data objectForKey:@"lastUnsuccessfulBuild"]];
    
    _firstBuild = [[FTAPIJobDetailBuildDataObject alloc] init];
    [_firstBuild processData:[data objectForKey:@"firstBuild"]];
    
    _healthReport = [[FTAPIJobDetailHealthDataObject alloc] init];
    [_healthReport processData:[[data objectForKey:@"healthReport"] objectAtIndex:0]];
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
    if (!data || [data isKindOfClass:[NSNull class]]) return;
    _number = [[data objectForKey:@"number"] integerValue];
    _urlString = [data objectForKey:@"url"];
}


@end


@implementation FTAPIJobDetailHealthDataObject

#pragma makr Data

- (void)processData:(NSDictionary *)data {
    NSLog(@"Health data: %@", data);
    _score = [[data objectForKey:@"score"] integerValue];
    _iconUrl = [data objectForKey:@"iconUrl"];
    _description = [data objectForKey:@"description"];
}


@end
