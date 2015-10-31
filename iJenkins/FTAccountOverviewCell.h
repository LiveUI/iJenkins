//
//  FTAccountOverviewCell.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 03/09/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTBasicCell.h"
#import "XYPieChart.h"


@class FTAccountOverviewCell;

@protocol FTAccountOverviewCellDelegate <NSObject>

- (void)accountOverviewCell:(FTAccountOverviewCell *)cell requiresFilterForStat:(FTAPIServerStatsDataObject *)stat;

@end


@interface FTAccountOverviewCell : FTBasicCell <XYPieChartDataSource, XYPieChartDelegate>

@property (nonatomic, strong) NSDictionary *jobsStats;

@property (nonatomic, weak) id <FTAccountOverviewCellDelegate> delegate;


@end
