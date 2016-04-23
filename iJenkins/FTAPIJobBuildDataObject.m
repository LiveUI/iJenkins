//
//  FTAPIJobBuildDataObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 13/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIJobBuildDataObject.h"


@implementation FTAPIJobBuildDataObject


#pragma mark Object implementation

- (FTHttpMethod)httpMethod {
    return FTHttpMethodPost;
}

- (NSString *)methodName {
    return [NSString stringWithFormat:@"%@build", _jobMethod];
}

- (NSDictionary *)payloadData {
    return nil;
}

- (void)processData:(NSDictionary *)data {
    [super processData:data];
}

- (void)processHeaders:(NSDictionary *)headers {
    [super processHeaders:headers];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityVeryHigh;
}

- (NSString *)suffix {
    return @"";
}

- (NSInteger)depth {
    return 1;
}

#pragma mark Initialization

- (id)initWithJobName:(NSString *)jobName jobMethod:(NSString *)jobMethod {
    self = [super init];
    if (self) {
        _jobName = jobName;
        _jobMethod = jobMethod;
    }
    return self;
}


@end
