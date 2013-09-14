//
//  FTStandaloneChartVieew.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 01/07/2013.
//  Copyright (c) 2013 Fuerte Innovations All rights reserved.
//

#import "XYPieChart.h"


@class FTStandaloneChartView;

@protocol FTStandaloneChartViewDelegate <NSObject>

- (void)standaloneChartView:(FTStandaloneChartView *)view didTapOvViewAtIndex:(NSInteger)index;

@end


@interface FTStandaloneChartView : FTView <XYPieChartDataSource, XYPieChartDelegate>

@property (nonatomic, weak) id <FTStandaloneChartViewDelegate> delegate;


@end
