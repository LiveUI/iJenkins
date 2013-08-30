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
    return [NSString stringWithFormat:@"job/%@/", _name];
}

- (NSDictionary *)payloadData {
    return nil;
}

- (void)processData:(NSDictionary *)data {
    [super processData:data];
    
    //NSLog(@"Data: %@", data);
    
    _color = [data objectForKey:@"color"];
    _name = [data objectForKey:@"name"];
    _urlString = [data objectForKey:@"url"];
}

#pragma mark Getters

- (FTAPIJobDetailDataObject *)jobDetail{
    if (!_isLoadingDetail && !_jobDetail) {
        _isLoadingDetail = YES;
        FTAPIJobDetailDataObject *jobDetailObject = [[FTAPIJobDetailDataObject alloc] initWithJobName:_name];
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


@end
