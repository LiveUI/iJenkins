//
//  FTAPIBuildQueueDataObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 03/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIBuildQueueDataObject.h"


@implementation FTAPIBuildQueueDataObject


#pragma mark - Object implementation

- (FTHttpMethod)httpMethod {
    return FTHttpMethodGet;
}

- (NSString *)methodName {
    return @"queue";
}

- (NSDictionary *)payloadData {
    return nil;
}

- (void)processData:(NSDictionary *)data {
    [super processData:data];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *item in [data objectForKey:@"items"]) {
        FTAPIBuildQueueItemDataObject *i = [[FTAPIBuildQueueItemDataObject alloc] init];
        [i processData:item];
        [arr addObject:i];
    }
    _items = [arr copy];
}

- (void)processHeaders:(NSDictionary *)headers {
    [super processHeaders:headers];
    
    NSLog(@"Build headers: %@", headers);
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityVeryHigh;
}


@end


@implementation FTAPIBuildQueueItemDataObject


#pragma mark - Processing data

- (void)processData:(NSDictionary *)data {
    _actions = [data objectForKey:@"actions"];
    _blocked = [[data objectForKey:@"blocked"] boolValue];
    _buildId = [[data objectForKey:@"buildId"] integerValue];
    _inQueueSince = [[data objectForKey:@"inQueueSince"] doubleValue];
    _params = [data objectForKey:@"params"];
    _stuck = [[data objectForKey:@"stuck"] boolValue];
    _task = [[FTAPIJobDataObject alloc] init];
    [_task processData:[data objectForKey:@"task"]];
    _urlString = [data objectForKey:@"url"];
    _why = [data objectForKey:@"why"];
    _buildableStartMilliseconds = [[data objectForKey:@"buildableStartMilliseconds"] doubleValue];
    _pending = [[data objectForKey:@"pending"] boolValue];
}


@end
