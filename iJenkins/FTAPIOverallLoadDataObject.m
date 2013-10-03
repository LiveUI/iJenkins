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
    
    _busyExecutors = [data objectForKey:@"busyExecutors"];
    _queueLength = [data objectForKey:@"queueLength"];
    _totalExecutors = [data objectForKey:@"totalExecutors"];
    _totalQueueLength = [data objectForKey:@"totalQueueLength"];
}

- (void)processHeaders:(NSDictionary *)headers {
    [super processHeaders:headers];
    
    NSLog(@"Build headers: %@", headers);
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityVeryHigh;
}


@end
