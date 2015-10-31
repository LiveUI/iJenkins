//
//  FTAPIComputerObject.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 07/10/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTAPIDataObject.h"


@interface FTAPIComputerObject : FTAPIDataObject <FTAPIDataAbstractObject>

@property (nonatomic, strong, readonly) NSString *displayName;
@property (nonatomic, strong, readonly) NSArray *computers; // Array of FTAPIComputerInfoObject objects
@property (nonatomic, readonly) NSInteger busyExecutors;
@property (nonatomic, readonly) NSInteger totalExecutors;


@end


@interface FTAPIComputerInfoObject : NSObject

@property (nonatomic, strong, readonly) NSString *displayName;
@property (nonatomic, strong, readonly) NSArray *executors; // Array of FTAPIComputerExecutorObject objects

@property (nonatomic, readonly) BOOL idle;
@property (nonatomic, readonly) BOOL jnlpAgent;
@property (nonatomic, readonly) BOOL launchSupported;
@property (nonatomic, strong, readonly) NSArray *loadStatistics;
@property (nonatomic, readonly) BOOL manualLaunchAllowed;
@property (nonatomic, strong, readonly) NSDictionary *monitorData;
@property (nonatomic, readonly) NSInteger numExecutors;
@property (nonatomic, readonly) NSInteger numActiveExecutors;
@property (nonatomic, readonly) BOOL offline;
@property (nonatomic, strong, readonly) NSDictionary *offlineCause;
@property (nonatomic, strong, readonly) NSString *offlineCauseReason;
@property (nonatomic, strong, readonly) NSArray *oneOffExecutors;
@property (nonatomic, readonly) BOOL temporarilyOffline;

- (void)processData:(NSDictionary *)data;


@end


@interface FTAPIComputerExecutorObject : NSObject

@property (nonatomic, strong, readonly) NSString *displayName;
@property (nonatomic, strong, readonly) FTAPIJobDataObject *currentExecutable;
@property (nonatomic, strong, readonly) NSDictionary *currentWorkUnit;
@property (nonatomic, readonly) BOOL idle;
@property (nonatomic, readonly) BOOL likelyStuck;
@property (nonatomic, readonly) NSInteger number;
@property (nonatomic, readonly) NSInteger progress;

- (void)processData:(NSDictionary *)data;


@end
