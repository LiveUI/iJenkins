//
//  FTAPIUserDetailDataObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 08/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIUserDetailDataObject.h"


@implementation FTAPIUserDetailDataObject

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
    
//    _displayName = data[@"displayName"];
//    
//    NSMutableArray *arr = [NSMutableArray array];
//    for (NSDictionary *d in data[@"computer"]) {
//        FTAPIComputerInfoObject *executor = [[FTAPIComputerInfoObject alloc] init];
//        [executor processData:d];
//        [arr addObject:executor];
//    }
//    _computers = [arr copy];
//    
//    _busyExecutors = [data[@"displayName"] integerValue];
//    _totalExecutors = [data[@"totalExecutors"] integerValue];
}

- (void)processHeaders:(NSDictionary *)headers {
    [super processHeaders:headers];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityHigh;
}

- (NSInteger)depth {
    return 1;
}


@end
