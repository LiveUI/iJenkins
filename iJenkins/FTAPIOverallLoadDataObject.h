//
//  FTAPIOverallLoadDataObject.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 03/10/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTAPIDataObject.h"


@interface FTAPIOverallLoadDataObject : FTAPIDataObject <FTAPIDataAbstractObject>

@property (nonatomic, strong, readonly) NSDictionary *busyExecutors;
@property (nonatomic, strong, readonly) NSDictionary *queueLength;
@property (nonatomic, strong, readonly) NSDictionary *totalExecutors;
@property (nonatomic, strong, readonly) NSDictionary *totalQueueLength;


@end
