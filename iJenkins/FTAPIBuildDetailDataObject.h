//
//  FTAPIBuildDetailDataObject.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 12/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIDataObject.h"


typedef enum {
    FTAPIBuildDetailDataObjectResultSuccess,
    FTAPIBuildDetailDataObjectResultUnstable,
    FTAPIBuildDetailDataObjectResultNone,
    FTAPIBuildDetailDataObjectResultFailure
} FTAPIBuildDetailDataObjectResult;


@class FTAPIBuildDetailChangeSetDataObject;

@interface FTAPIBuildDetailDataObject : FTAPIDataObject <FTAPIDataAbstractObject>

@property (nonatomic, readonly) NSInteger buildNumber;
@property (nonatomic, strong, readonly) NSString *jobName;

@property (nonatomic) FTAPIBuildDetailDataObjectResult result;
@property (nonatomic) BOOL building;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval estimatedDuration;
@property (nonatomic) BOOL keepLog;
@property (nonatomic) NSTimeInterval timestamp;

@property (nonatomic, strong) NSArray *actions;

@property (nonatomic, strong) NSString *fullDisplayName;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *resultString;
@property (nonatomic, strong) NSString *builtOn;
@property (nonatomic, strong) NSDictionary *executor;
@property (nonatomic, strong) NSArray *causes;
@property (nonatomic, strong) NSDate *dateExecuted;
@property (nonatomic, strong) FTAPIBuildDetailChangeSetDataObject *changeSet;
@property (nonatomic, strong) NSArray *mavenArtifacts;
@property (nonatomic, strong) NSString *mavenVersionUsed;

- (id)initWithJobName:(NSString *)jobName andBuildNumber:(NSInteger)buildNumber;


@end


@interface FTAPIBuildDetailChangeSetDataObject : NSObject

@property (nonatomic, strong) NSString *shortDescription;

- (void)processData:(NSDictionary *)data;


@end


@interface FTAPIBuildDetailCauseDataObject : NSObject

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) NSArray *revisions;

- (void)processData:(NSDictionary *)data;


@end
