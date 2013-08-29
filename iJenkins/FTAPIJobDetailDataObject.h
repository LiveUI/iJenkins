//
//  FTAPIJobDetailDataObject.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIDataObject.h"


@class FTAPIJobDetailBuildDataObject;

@interface FTAPIJobDetailDataObject : FTAPIDataObject <FTAPIDataAbstractObject>

@property (nonatomic, strong) FTAPIJobDetailBuildDataObject *lastBuild;

- (id)initWithJobName:(NSString *)jobName;


@end


@interface FTAPIJobDetailBuildDataObject : NSObject

@property (nonatomic) NSInteger number;
@property (nonatomic, strong) NSString *urlString;

- (void)processData:(NSDictionary *)data;


@end
