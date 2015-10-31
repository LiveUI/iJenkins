//
//  FTAPIComputerObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 07/10/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTAPIComputerObject.h"


@implementation FTAPIComputerObject


#pragma mark - Object implementation

- (FTHttpMethod)httpMethod {
    return FTHttpMethodGet;
}

- (NSString *)methodName {
    return @"computer/";
}

- (NSDictionary *)payloadData {
    return nil;
}

- (void)processData:(NSDictionary *)data {
    [super processData:data];
    
    _displayName = data[@"displayName"];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *d in data[@"computer"]) {
        FTAPIComputerInfoObject *executor = [[FTAPIComputerInfoObject alloc] init];
        [executor processData:d];
        [arr addObject:executor];
    }
    _computers = [arr copy];
    
    _busyExecutors = [data[@"displayName"] integerValue];
    _totalExecutors = [data[@"totalExecutors"] integerValue];
}

- (void)processHeaders:(NSDictionary *)headers {
    [super processHeaders:headers];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityVeryHigh;
}

- (NSInteger)depth {
    return 1;
}


@end


@implementation FTAPIComputerInfoObject

#pragma mark Data processing

- (void)processData:(NSDictionary *)data {
    _displayName = data[@"displayName"];
    NSMutableArray *arr = [NSMutableArray array];
    _numActiveExecutors = 0;
    for (NSDictionary *d in data[@"executors"]) {
        if (![d[@"currentExecutable"] isKindOfClass:[NSNull class]]) {
            FTAPIComputerExecutorObject *executor = [[FTAPIComputerExecutorObject alloc] init];
            [executor processData:d];
            [arr addObject:executor];
            _numActiveExecutors++;
        }
        else {
            [arr addObject:[NSNull null]];
        }
    }
    _executors = [arr copy];
    _idle = [data[@"idle"] boolValue];
    _jnlpAgent = [data[@"jnlpAgent"] boolValue];
    _launchSupported = [data[@"launchSupported"] boolValue];
    _loadStatistics = data[@"loadStatistics"];
    _manualLaunchAllowed = [data[@"manualLaunchAllowed"] boolValue];
    _monitorData = data[@"monitorData"];
    _numExecutors = [data[@"numExecutors"] integerValue];
    _offline = [data[@"offline"] boolValue];
    _offlineCause = data[@"offlineCause"];
    _offlineCauseReason = data[@"offlineCauseReason"];
    _oneOffExecutors = data[@"oneOffExecutors"];
    _temporarilyOffline = [data[@"temporarilyOffline"] boolValue];
}


@end


@implementation FTAPIComputerExecutorObject

#pragma mark Data processing

- (void)processData:(NSDictionary *)data {
    _displayName = data[@"displayName"];
    _currentExecutable = [[FTAPIJobDataObject alloc] init];
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:data[@"currentExecutable"]];
    NSArray *urlParts = [[d objectForKey:@"url"] componentsSeparatedByString:@"/"];
    NSInteger count = urlParts.count;
    count -= 2;
    if ([(NSString *)urlParts.lastObject length] == 0) count--;
    [d setValue:urlParts[count] forKey:@"name"];
    [_currentExecutable processData:d];
    _currentWorkUnit = data[@"currentWorkUnit"];
    _idle = [data[@"idle"] boolValue];
    _likelyStuck = [data[@"likelyStuck"] boolValue];
    _number = [data[@"number"] integerValue];
    _progress = [data[@"progress"] integerValue];
}


@end
