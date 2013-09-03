//
//  FTAPIJobsDataObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIJobsDataObject.h"


@implementation FTAPIJobsDataObject


#pragma mark Object implementation

- (FTHttpMethod)httpMethod {
    return FTHttpMethodGet;
}

- (NSString *)methodName {
    return @"view/All/";
}

- (NSDictionary *)payloadData {
    return nil;
}

- (void)processData:(NSDictionary *)data {
    [super processData:data];
    
    NSArray *arr = [data objectForKey:@"jobs"];
    NSMutableArray *jobs = [NSMutableArray array];
    _jobsStats = [NSMutableDictionary dictionary];
    for (NSDictionary *d in arr) {
        FTAPIJobDataObject *job = [[FTAPIJobDataObject alloc] init];
        [job processData:d];
        [jobs addObject:job];
        
        if (![_jobsStats objectForKey:job.color]) {
            FTAPIJobsStatsDataObject *s = [[FTAPIJobsStatsDataObject alloc] init];
            [s setCount:1];
            [s setColor:job.color];
            [s setFullColor:job.fullColor];
            [_jobsStats setValue:s forKey:job.color];
        }
        else {
            FTAPIJobsStatsDataObject *s = (FTAPIJobsStatsDataObject *)[_jobsStats objectForKey:job.color];
            s.count++;
        }
    }
    _jobs = jobs;
}


@end


@implementation FTAPIJobsStatsDataObject

@end
