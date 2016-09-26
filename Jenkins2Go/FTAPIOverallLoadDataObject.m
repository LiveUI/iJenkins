//
//  FTAPIOverallLoadDataObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 03/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIOverallLoadDataObject.h"


@implementation FTAPIOverallLoadDataObject


#pragma mark Object implementation

- (FTHttpMethod)httpMethod {
    return FTHttpMethodGet;
}

- (NSString *)methodName {
    return @"overallLoad";
}

- (NSDictionary *)payloadData {
    return nil;
}

- (void)processData:(NSDictionary *)data {
    [super processData:data];
    
    _busyExecutors = data[@"busyExecutors"];
    _queueLength = data[@"queueLength"];
    _totalExecutors = data[@"totalExecutors"];
    _totalQueueLength = data[@"totalQueueLength"];
}

- (void)processHeaders:(NSDictionary *)headers {
    [super processHeaders:headers];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityVeryHigh;
}


@end
