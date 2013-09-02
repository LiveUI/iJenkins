//
//  FTJobCell.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTBasicCell.h"
#import "FTAPIJobDataObject.h"


@interface FTJobCell : FTBasicCell <FTAPIJobDataObjectDelegate>

@property (nonatomic, strong) FTAPIJobDataObject *job;

- (void)setDescriptionText:(NSString *)text;
- (void)reset;


@end
