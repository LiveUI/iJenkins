//
//  FTAPIBuildQueueDataObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 03/10/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTAPIBuildQueueDataObject.h"


@implementation FTAPIBuildQueueDataObject


#pragma mark - Object implementation

- (FTHttpMethod)httpMethod {
    return FTHttpMethodGet;
}

- (NSString *)methodName {
    return @"queue/";
}

- (NSDictionary *)payloadData {
    return nil;
}

- (void)processData:(NSDictionary *)data {
    [super processData:data];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *item in data[@"items"]) {
        FTAPIBuildQueueItemDataObject *i = [[FTAPIBuildQueueItemDataObject alloc] init];
        [i processData:item];
        [arr addObject:i];
    }
    _items = [arr copy];
}

- (void)processHeaders:(NSDictionary *)headers {
    [super processHeaders:headers];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityVeryHigh;
}


@end


@implementation FTAPIBuildQueueItemDataObject


#pragma mark - Processing data

- (void)processData:(NSDictionary *)data {
    _actions = data[@"actions"];
    _blocked = [data[@"blocked"] boolValue];
    _buildId = [data[@"buildId"] integerValue];
    _inQueueSince = [data[@"inQueueSince"] doubleValue];
    _params = data[@"params"];
    _stuck = [data[@"stuck"] boolValue];
    _task = [[FTAPIJobDataObject alloc] init];
    [_task processData:data[@"task"]];
    _urlString = data[@"url"];
    _why = data[@"why"];
    _buildableStartMilliseconds = [data[@"buildableStartMilliseconds"] doubleValue];
    _pending = [data[@"pending"] boolValue];
}


@end
