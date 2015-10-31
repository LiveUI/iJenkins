//
//  FTJobCell.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTBasicCell.h"


@interface FTJobCell : FTBasicCell <FTAPIJobDataObjectDelegate>

@property (nonatomic, strong) FTAPIJobDataObject *job;

@property (nonatomic, strong) UIView *statusColorView;
@property (nonatomic, strong) UIImageView *buildScoreView;
@property (nonatomic, strong) UILabel *buildIdView;

- (void)setDescriptionText:(NSString *)text;
- (void)reset;

- (void)resetScoreIcon;
- (void)resetStatusColor;


@end
