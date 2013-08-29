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
    return @"";
}

- (NSDictionary *)payloadData {
    return nil;
}

- (void)processData:(NSDictionary *)data {
    [super processData:data];
    NSLog(@"Data: %@", data);
    NSArray *arr = [data objectForKey:@"jobs"];
    NSMutableArray *jobs = [NSMutableArray array];
    for (NSDictionary *d in arr) {
        FTAPIJobDataObject *job = [[FTAPIJobDataObject alloc] init];
        [job processData:d];
        [jobs addObject:job];
    }
    _jobs = jobs;
}




@end
