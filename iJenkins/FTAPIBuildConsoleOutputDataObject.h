//
//  FTAPIBuildConsoleOutputDataObject.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 04/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIDataObject.h"

@interface FTAPIBuildConsoleOutputDataObject : FTAPIDataObject <FTAPIDataAbstractObject>

@property (nonatomic, readonly) NSString *outputText;
@property (nonatomic, readonly) BOOL isMoreData;

@property (nonatomic, readonly) NSString *jobName;
@property (nonatomic, readonly) NSInteger buildNumber;

- (id)initWithJobName:(NSString *)jobName andBuildNumber:(NSInteger)buildNumber;


@end
