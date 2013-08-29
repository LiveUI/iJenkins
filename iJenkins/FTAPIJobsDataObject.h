//
//  FTAPIJobsDataObject.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIJobDataObject.h"


@interface FTAPIJobsDataObject : FTAPIDataObject <FTAPIDataAbstractObject>

@property (nonatomic, strong) NSArray *jobs;


@end
