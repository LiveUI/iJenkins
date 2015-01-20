//
//  FTAPIServerDataObject.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIJobDataObject.h"


@class FTAPIServerViewDataObject;

@interface FTAPIServerDataObject : FTAPIDataObject <FTAPIDataAbstractObject>

@property (nonatomic, strong) FTAPIServerViewDataObject *viewToLoad;

@property (nonatomic, strong, readonly) NSString *mode;
@property (nonatomic, strong, readonly) NSString *nodeDescription;
@property (nonatomic, strong, readonly) NSString *nodeName;
@property (nonatomic, strong, readonly) NSString *desc;
@property (nonatomic, strong, readonly) FTAPIServerViewDataObject *primaryView;
@property (nonatomic, readonly) NSInteger numExecutors;
@property (nonatomic, readonly) NSInteger slaveAgentPort;
@property (nonatomic, readonly) BOOL quietingDown;
@property (nonatomic, readonly) BOOL useCrumbs;
@property (nonatomic, readonly) BOOL useSecurity;
@property (nonatomic, strong, readonly) NSArray *assignedLabels;
@property (nonatomic, strong, readonly) NSArray *jobs;
@property (nonatomic, strong, readonly) NSArray *views;
@property (nonatomic, strong, readonly) NSDictionary *jobsStats;


@end


@interface FTAPIServerStatsDataObject : NSObject

@property (nonatomic) NSInteger count;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *fullColor;
@property (nonatomic, strong) UIColor *realColor;


@end


@interface FTAPIServerViewDataObject : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *urlString;


@end
