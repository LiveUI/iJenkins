//
//  FTAPIJobBuildDataObject.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 13/09/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTAPIDataObject.h"


typedef enum {
    FTAPIJobBuildDataObjectResultFailure,
    FTAPIJobBuildDataObjectResultSuccess
} FTAPIJobBuildDataObjectResult;


@interface FTAPIJobBuildDataObject : FTAPIDataObject <FTAPIDataAbstractObject>

@property (nonatomic, strong, readonly) NSString *jobName;
@property (nonatomic, readonly) FTAPIJobBuildDataObjectResult result;

- (id)initWithJobName:(NSString *)jobName;


@end
