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
    return [NSString stringWithFormat:@"job/%@/%d/", _jobName, _buildNumber];
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

- (UIColor *)colorForString:(NSString *)resultString {
    if (!resultString || [resultString isKindOfClass:[NSNull class]]) {
        return [UIColor colorWithWhite:0 alpha:0.1];
    }
    if ([resultString isEqualToString:@"SUCCESS"]) {
        //return [UIColor colorWithHexString:@"6DD900"]; // Green
        return [UIColor colorWithHexString:@"007EF3"];
    }
    else if ([resultString isEqualToString:@"UNSTABLE"]) {
        return [UIColor colorWithHexString:@"FFDC73"];
    }
    else if ([resultString isEqualToString:@"FAILURE"]) {
        return [UIColor colorWithHexString:@"FF4000"];
    }
    else if ([resultString isEqualToString:@"ABORTED"]) {
        return [UIColor grayColor];
    }
    else {
        return [UIColor colorWithWhite:0 alpha:0.1];
    }
}

- (void)processData:(NSDictionary *)data {
    [super processData:data];
    
    NSLog(@"Data: %@", data);
    
    _timestamp = [[data objectForKey:@"timestamp"] integerValue];
    
    _fullDisplayName = [data objectForKey:@"fullDisplayName"];
    _urlString = [data objectForKey:@"url"];
    _resultString = [data objectForKey:@"result"];
    _builtOn = [data objectForKey:@"builtOn"];
    _executor = [data objectForKey:@"executor"];
    
    _actions = [data objectForKey:@"actions"];
    if (_actions) {
        for (NSDictionary *action in _actions) {
            if ([action objectForKey:@"causes"]) {
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
    
    if ([data objectForKey:@"changeSet"]) {
        _changeSet = [[FTAPIBuildDetailChangeSetDataObject alloc] init];
        [_changeSet processData:[data objectForKey:@"changeSet"]];
    }
    
    _mavenArtifacts = [data objectForKey:@"mavenArtifacts"];
    _mavenVersionUsed = [data objectForKey:@"mavenVersionUsed"];
    
    _result = [self resultForString:_resultString];
    _building = [[data objectForKey:@"building"] boolValue];
    _duration = [[data objectForKey:@"duration"] integerValue];
    _estimatedDuration = [[data objectForKey:@"estimatedDuration"] integerValue];
    _keepLog = [[data objectForKey:@"keepLog"] boolValue];
    
    _realColor = [self colorForString:_resultString];
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
