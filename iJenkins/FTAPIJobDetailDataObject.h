//
//  FTAPIJobDetailDataObject.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIDataObject.h"


@class FTAPIJobDetailBuildDataObject, FTAPIJobDetailHealthDataObject, FTAPIBuildDetailDataObject;

@interface FTAPIJobDetailDataObject : FTAPIDataObject <FTAPIDataAbstractObject>

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *description;
@property (nonatomic) BOOL buildable;

@property (nonatomic, strong) NSArray *builds;
@property (nonatomic, strong) FTAPIJobDetailBuildDataObject *lastBuild;
@property (nonatomic, strong) FTAPIJobDetailBuildDataObject *lastCompletedBuild;
@property (nonatomic, strong) FTAPIJobDetailBuildDataObject *lastFailedBuild;
@property (nonatomic, strong) FTAPIJobDetailBuildDataObject *lastSuccessfulBuild;
@property (nonatomic, strong) FTAPIJobDetailBuildDataObject *lastUnstableBuild;
@property (nonatomic, strong) FTAPIJobDetailBuildDataObject *lastUnsuccessfulBuild;
@property (nonatomic, strong) FTAPIJobDetailBuildDataObject *firstBuild;

@property (nonatomic, strong) FTAPIJobDetailHealthDataObject *healthReport;
@property (nonatomic, strong) NSArray *healthReports;

- (id)initWithJobName:(NSString *)jobName;


@end


@interface FTAPIJobDetailBuildDataObject : NSObject

@property (nonatomic) NSInteger number;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) FTAPIBuildDetailDataObject *buildDetail;

- (void)processData:(NSDictionary *)data;

- (void)loadBuildDetailWithSuccessBlock:(void (^)(FTAPIBuildDetailDataObject *data))success forJobName:(NSString *)jobName;;


@end


@interface FTAPIJobDetailHealthDataObject : NSObject

@property (nonatomic) NSInteger score;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *iconUrl;

- (void)processData:(NSDictionary *)data;


@end
