//
//  FTAPIServerDataObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIServerDataObject.h"


@implementation FTAPIServerDataObject


#pragma mark Object implementation

- (FTHttpMethod)httpMethod {
    return FTHttpMethodGet;
}

- (NSString *)methodName {
    if (_viewToLoad) {
        return [NSString stringWithFormat:@"view/%@/", _viewToLoad.name];
    }
    else return @"";
}

- (NSDictionary *)payloadData {
    return nil;
}

- (void)processData:(NSDictionary *)data {
    [super processData:data];
    
    _mode = [data objectForKey:@"mode"];
    _nodeDescription = [data objectForKey:@"nodeDescription"];
    _nodeName = [data objectForKey:@"nodeName"];
    _description = [data objectForKey:@"description"];
    
    _primaryView = [[FTAPIServerViewDataObject alloc] init];
    [_primaryView setName:[[data objectForKey:@"primaryView"] objectForKey:@"name"]];
    [_primaryView setUrlString:[[data objectForKey:@"primaryView"] objectForKey:@"url"]];
    
    _numExecutors = [[data objectForKey:@"numExecutors"] integerValue];
    _slaveAgentPort = [[data objectForKey:@"slaveAgentPort"] integerValue];
    _quietingDown = [[data objectForKey:@"quietingDown"] boolValue];
    _useCrumbs = [[data objectForKey:@"useCrumbs"] boolValue];
    _useSecurity = [[data objectForKey:@"useSecurity"] boolValue];
    
    _assignedLabels = [data objectForKey:@"assignedLabels"];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[[data objectForKey:@"views"] count]];
    for (NSDictionary *d in [data objectForKey:@"views"]) {
        FTAPIServerViewDataObject *view = [[FTAPIServerViewDataObject alloc] init];
        [view setName:[d objectForKey:@"name"]];
        [view setUrlString:[d objectForKey:@"url"]];
        [arr addObject:view];
    }
    _views = arr;
    
    arr = [data objectForKey:@"jobs"];
    NSMutableArray *jobs = [NSMutableArray array];
    _jobsStats = [NSMutableDictionary dictionary];
    for (NSDictionary *d in arr) {
        FTAPIJobDataObject *job = [[FTAPIJobDataObject alloc] init];
        [job processData:d];
        [jobs addObject:job];
        
        if (![_jobsStats objectForKey:job.color]) {
            FTAPIServerStatsDataObject *s = [[FTAPIServerStatsDataObject alloc] init];
            [s setCount:1];
            [s setColor:job.color];
            [s setFullColor:job.fullColor];
            [s setRealColor:job.realColor];
            [_jobsStats setValue:s forKey:job.color];
        }
        else {
            FTAPIServerStatsDataObject *s = (FTAPIServerStatsDataObject *)[_jobsStats objectForKey:job.color];
            s.count++;
        }
    }
    _jobs = jobs;
}


@end


@implementation FTAPIServerStatsDataObject

@end


@implementation FTAPIServerViewDataObject

@end
