//
//  FTAPIJobDataObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIJobDataObject.h"


@interface FTAPIJobDataObject ()

@property (nonatomic) BOOL isLoadingDetail;

@end


@implementation FTAPIJobDataObject


#pragma mark Data

- (void)loadDetail {
    
}

#pragma mark Object implementation

- (FTHttpMethod)httpMethod {
    return FTHttpMethodGet;
}

- (NSString *)methodName {
    if (_parentJob) {
        return [NSString stringWithFormat:@"%@job/%@/", _parentJob.methodName, _name];
    }
    return [NSString stringWithFormat:@"job/%@/", _name];
}

- (NSDictionary *)payloadData {
    return nil;
}

- (void)processData:(NSDictionary *)data {
    [super processData:data];
//    NSLog(@"Process: %@", data);
    _fullColor = data[@"color"];
    NSArray *colorPieces = [_fullColor componentsSeparatedByString:@"_"];
    _color = [colorPieces objectAtIndex:0];
    _animating = (colorPieces.count > 1);
    _name = [data[@"name"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _urlString = data[@"url"];
    NSMutableArray *childJobs = [NSMutableArray array];
    for (NSDictionary *job in data[@"jobs"]) {
        FTAPIJobDataObject *jobObject = [[FTAPIJobDataObject alloc] init];
        [jobObject processData:job];
        [jobObject setParentJob:self];
        [childJobs addObject:jobObject];
    }
    if (childJobs.count > 0) {
        self.childJobs = childJobs;
    }
}

#pragma mark Getters

- (FTAPIJobDetailDataObject *)jobDetail{
    if (!_isLoadingDetail && !_jobDetail) {
        _isLoadingDetail = YES;
        FTAPIJobDetailDataObject *jobDetailObject = [[FTAPIJobDetailDataObject alloc] initWithJobName:_name jobMethod:self.methodName];
        [FTAPIConnector connectWithObject:jobDetailObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
            _isLoadingDetail = NO;
            _jobDetail = jobDetailObject;
            if ([_delegate respondsToSelector:@selector(jobDataObject:didFinishLoadingJobDetail:)]) {
                [_delegate jobDataObject:self didFinishLoadingJobDetail:_jobDetail];
            }
        }];
    }
    return _jobDetail;
}

- (UIColor *)realColor {
    return [UIColor colorForJenkinsColorCode:_color];
}


@end
