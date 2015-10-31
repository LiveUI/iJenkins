//
//  FTAPIBuildQueueDataObject.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 03/10/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTAPIDataObject.h"


@interface FTAPIBuildQueueDataObject : FTAPIDataObject <FTAPIDataAbstractObject>

@property (nonatomic, strong, readonly) NSArray *items; // Array of FTAPIBuildQueueItemDataObject objects


@end


@interface FTAPIBuildQueueItemDataObject : NSObject

@property (nonatomic, strong, readonly) NSArray *actions;
@property (nonatomic, readonly) BOOL blocked;
@property (nonatomic, readonly) NSInteger buildId;
@property (nonatomic, readonly) NSTimeInterval inQueueSince;
@property (nonatomic, strong, readonly) NSString *params;
@property (nonatomic, readonly) BOOL stuck;
@property (nonatomic, strong, readonly) FTAPIJobDataObject *task;
@property (nonatomic, strong, readonly) NSString *urlString;
@property (nonatomic, strong, readonly) NSString *why;
@property (nonatomic, readonly) NSTimeInterval buildableStartMilliseconds;
@property (nonatomic, readonly) BOOL pending;

- (void)processData:(NSDictionary *)data;


@end



