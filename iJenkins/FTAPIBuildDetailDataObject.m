//
//  FTAPIBuildDetailDataObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 12/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIBuildDetailDataObject.h"


@implementation FTAPIBuildDetailDataObject


#pragma mark Object implementation

- (FTHttpMethod)httpMethod {
    return FTHttpMethodGet;
}

- (NSString *)methodName {
    return [NSString stringWithFormat:@"job/%@/%ld/", _jobName, (long)_buildNumber];
}

- (NSDictionary *)payloadData {
    return nil;
}

- (FTAPIBuildDetailDataObjectResult)resultForString:(NSString *)resultString {
    if (!resultString || [resultString isKindOfClass:[NSNull class]]) {
        return FTAPIBuildDetailDataObjectResultNone;
    }
    if ([resultString isEqualToString:@"SUCCESS"]) {
        return FTAPIBuildDetailDataObjectResultSuccess;
    }
    else if ([resultString isEqualToString:@"UNSTABLE"]) {
        return FTAPIBuildDetailDataObjectResultUnstable;
    }
    else if ([resultString isEqualToString:@"FAILURE"]) {
        return FTAPIBuildDetailDataObjectResultFailure;
    }
    else {
        return FTAPIBuildDetailDataObjectResultNone;
    }
}

- (void)processData:(NSDictionary *)data {
    [super processData:data];
    
    _timestamp = (int)([data[@"timestamp"] doubleValue] / 1000);
    _fullDisplayName = data[@"fullDisplayName"];
    _urlString = data[@"url"];
    _resultString = data[@"result"];
    _builtOn = data[@"builtOn"];
    _executor = data[@"executor"];
    
    _actions = data[@"actions"];
    if (_actions) {
        for (NSDictionary *action in _actions) {
            if ((NSNull *)action != [NSNull null] && [action objectForKey:@"causes"]) {
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[[action objectForKey:@"causes"] count]];
                for (NSDictionary *cause in [action objectForKey:@"causes"]) {
                    FTAPIBuildDetailCauseDataObject *c = [[FTAPIBuildDetailCauseDataObject alloc] init];
                    [c processData:cause];
                    [arr addObject:c];
                }
                _causes = [NSArray arrayWithArray:arr];
            }
        }
        
    }
    
    _dateExecuted = [NSDate dateWithTimeIntervalSince1970:_timestamp];
    if (data[@"changeSet"] && [data[@"changeSet"] count] != 0) {
        _changeSet = [[FTAPIBuildDetailChangeSetDataObject alloc] init];
        [_changeSet processData:data[@"changeSet"]];
    }
    
    _mavenArtifacts = data[@"mavenArtifacts"];
    _mavenVersionUsed = data[@"mavenVersionUsed"];
    
    _result = [self resultForString:_resultString];
    _building = [data[@"building"] boolValue];
    _duration = [data[@"duration"] integerValue];
    _estimatedDuration = [data[@"estimatedDuration"] integerValue];
    _keepLog = [data[@"keepLog"] boolValue];
    
    _realColor = [UIColor colorForJenkinsBuildStatus:_resultString];
}

#pragma mark Connection handling

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityHigh;
}

#pragma mark Initialization

- (id)initWithJobName:(NSString *)jobName andBuildNumber:(NSInteger)buildNumber {
    self = [super init];
    if (self) {
        _jobName = jobName;
        _buildNumber = buildNumber;
    }
    return self;
}


@end


@implementation FTAPIBuildDetailChangeSetDataObject


#pragma mark Data

- (void)processData:(NSDictionary *)data {
    _kind = data[@"kind"];
    _items = data[@"items"];
    _revisions = data[@"revisions"];
}


@end


@implementation FTAPIBuildDetailCauseDataObject


#pragma mark Data

- (void)processData:(NSDictionary *)data {
    _shortDescription = data[@"shortDescription"];
}


@end
