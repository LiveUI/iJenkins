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
    
    _displayName = [data objectForKey:@"displayName"];
    _name = [data objectForKey:@"name"];
    _url = [data objectForKey:@"url"];
    _description = [data objectForKey:@"description"];
    _buildable = [[data objectForKey:@"buildable"] boolValue];
    
    int count = [[data objectForKey:@"builds"] count];
    if (count > 0) {
        int x = 0;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:count];
        for (NSDictionary *d in [data objectForKey:@"builds"]) {
            FTAPIJobDetailBuildDataObject *build = [[FTAPIJobDetailBuildDataObject alloc] init];
            [build processData:d];
            [arr addObject:build];
            x++;
        }
        _builds = [NSArray arrayWithArray:arr];
    }
    
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
    
    count = [[data objectForKey:@"healthReport"] count];
    if (count > 0) {
        int x = 0;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:count];
        for (NSDictionary *d in [data objectForKey:@"healthReport"]) {
            FTAPIJobDetailHealthDataObject *healthReport = [[FTAPIJobDetailHealthDataObject alloc] init];
            [healthReport processData:d];
            if (x == 0) {
                _healthReport = healthReport;
            }
            [arr addObject:healthReport];
            x++;
        }
        _healthReports = [NSArray arrayWithArray:arr];
    }
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

#pragma mark Data

- (void)processData:(NSDictionary *)data {
    if (!data || [data isKindOfClass:[NSNull class]]) return;
    _number = [[data objectForKey:@"number"] integerValue];
    _urlString = [data objectForKey:@"url"];
}

- (void)loadBuildDetailWithSuccessBlock:(void (^)(FTAPIBuildDetailDataObject *))success forJobName:(NSString *)jobName {
    if (_isLoading) return;
    _isLoading = YES;
    FTAPIBuildDetailDataObject *buildObject = [[FTAPIBuildDetailDataObject alloc] initWithJobName:jobName andBuildNumber:_number];
    [FTAPIConnector connectWithObject:buildObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
        _buildDetail = buildObject;
        if (success) {
            success(buildObject);
        }
        _isLoading = NO;
    }];
}


@end


@implementation FTAPIJobDetailHealthDataObject

#pragma makr Data

- (void)processData:(NSDictionary *)data {
    _score = [[data objectForKey:@"score"] integerValue];
    _iconUrl = [data objectForKey:@"iconUrl"];
    _description = [data objectForKey:@"description"];
}


@end
