//
//  FTAccountOverviewCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 03/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAccountOverviewCell.h"
#import "FTChartOverlay.h"


@interface FTAccountOverviewCell ()

@property (nonatomic, strong) XYPieChart *chart;
@property (nonatomic, assign) NSUInteger sliceAnimationCount;

@property (nonatomic, strong) UIView *chartCenter;
@property (nonatomic, strong) FTChartOverlay *chartOverlay;
@property (nonatomic, strong, readonly) UILabel *descriptionLabel;
@property (nonatomic, strong, readonly) UILabel *countLabel;
@property (nonatomic, strong) NSTimer *deselectTimer;
@property (nonatomic, strong) UIView *clickableOverlay;

@end


@implementation FTAccountOverviewCell


#pragma mark Data

- (NSString *)titleForCode:(NSString *)code {
    NSDictionary *dic = @{@"NOTBUILT": @"Not built", @"ABORTED": @"Aborted", @"RED": @"Failed", @"DISABLED": @"Disabled", @"YELLOW": @"Unstable", @"BLUE": @"Success"};
    return FTLangGet([dic objectForKey:code]);
}

#pragma mark Creating elements

- (void)createPieChart {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(65, 14, 190, 190)];
    [v setBackgroundColor:[UIColor colorWithHexString:@"E7E7E7" andAlpha:1]];
    [v.layer setCornerRadius:(v.height / 2)];
    [self addSubview:v];
    
    _chart = [[XYPieChart alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [_chart setUserInteractionEnabled:YES];
    [_chart setDataSource:self];
    [_chart setDelegate:self];
    [_chart setStartPieAngle:DegreesToRadians(-90)];
    [_chart setAnimationSpeed:0.8];
    [_chart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [_chart setLabelShadowColor:[UIColor clearColor]];
    [_chart setSelectedSliceOffsetRadius:5];
    [_chart setCenter:v.center];
    [self addSubview:_chart];
    
    CGFloat chartWidth = 24;
    _chartCenter = [[UIView alloc] initWithFrame:CGRectMake(chartWidth, chartWidth, (_chart.width - (2 * chartWidth)), (_chart.width - (2 * chartWidth)))];
    [_chartCenter setUserInteractionEnabled:YES];
    [_chartCenter setBackgroundColor:[UIColor whiteColor]];
    [_chartCenter.layer setCornerRadius:(_chartCenter.width / 2)];
    [_chart addSubview:_chartCenter];
    
    _chartOverlay = [[FTChartOverlay alloc] initWithFrame:_chart.bounds];
    [_chartOverlay setUserInteractionEnabled:NO];
    [_chartOverlay setAlpha:0];
    [_chart addSubview:_chartOverlay];
    
    CGFloat cr = 152;
    v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cr, cr)];
    [v setBackgroundColor:[UIColor colorWithHexString:@"E7E7E7" andAlpha:1]];
    [v.layer setCornerRadius:(v.frame.size.width / 2)];
    [_chart addSubview:v];
    [v centerInSuperview];
    
    cr = 142;
    UIView *topWhiteOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cr, cr)];
    [topWhiteOverlay setUserInteractionEnabled:NO];
    [topWhiteOverlay setBackgroundColor:[UIColor whiteColor]];
    [topWhiteOverlay.layer setCornerRadius:(cr / 2)];
    [_chart addSubview:topWhiteOverlay];
    [topWhiteOverlay centerInSuperview];
    
    UIView *copyHolder = [[UIView alloc] initWithFrame:_chartCenter.frame];
    [copyHolder setUserInteractionEnabled:NO];
    [_chart addSubview:copyHolder];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 73, _chart.width, 22)];
    [_countLabel setUserInteractionEnabled:NO];
    [_countLabel setTextColor:[UIColor colorWithHexString:@"0076FF"]];
    [_countLabel setBackgroundColor:[UIColor clearColor]];
    [_countLabel setFont:[UIFont boldSystemFontOfSize:24]];
    [copyHolder addSubview:_countLabel];
    [_countLabel sizeToFit];
    [_countLabel centerHorizontally];
    
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (_countLabel.bottom - 20), _chart.width, 22)];
    [_descriptionLabel setUserInteractionEnabled:NO];
    [_descriptionLabel setTextAlignment:NSTextAlignmentCenter];
    [_descriptionLabel setTextColor:[UIColor colorWithHexString:@"0076FF"]];
    [_descriptionLabel setBackgroundColor:[UIColor clearColor]];
    [_descriptionLabel setFont:[UIFont systemFontOfSize:14]];
    [copyHolder addSubview:_descriptionLabel];
    [_descriptionLabel centerHorizontally];
    
    [self showTotalJobs];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self createPieChart];
}

#pragma mark Animation

- (void)startInitialChartSliceAnimation {
    _sliceAnimationCount = 0;
    NSTimer *chartAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(initialChartSliceAnimation:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:chartAnimationTimer forMode:NSRunLoopCommonModes];
}

- (void)deselectSliceWithTimer:(NSTimer *)timer {
    [_chart setSliceDeselectedAtIndex:[[timer userInfo] integerValue]];
}

- (void)initialChartSliceAnimation:(NSTimer *)timer {
    if (_sliceAnimationCount <= _jobsStats.allKeys.count) {
        [self pieChart:_chart didSelectSliceAtIndex:_sliceAnimationCount];
        [_chart setSliceSelectedAtIndex:_sliceAnimationCount];
        NSNumber *sliceNumber = [NSNumber numberWithInteger:_sliceAnimationCount];
        [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(deselectSliceWithTimer:) userInfo:sliceNumber repeats:NO];
        _sliceAnimationCount++;
    }
    else {
        [timer invalidate];
        timer = nil;
        self.userInteractionEnabled = YES;
    }
}

#pragma mark Settings

- (void)setJobsStats:(NSDictionary *)jobsStats {
    _jobsStats = jobsStats;
    [_chart reloadData];
    [self startInitialChartSliceAnimation];
}

- (void)showTotalJobs {
    int count = 0;
    for (NSString *key in _jobsStats.allKeys) {
        FTAPIServerStatsDataObject *s = [_jobsStats objectForKey:key];
        count += s.count;
    }
    [_countLabel setText:[NSString stringWithFormat:@"%d", count]];
    [_countLabel sizeToFit];
    [_countLabel centerHorizontally];
    [_descriptionLabel setText:FTLangGet(@"Jobs total")];
}

#pragma mark Pie chart delegate & datasource methods

- (UIColor *)colorForItemAtIndex:(NSInteger)index {
    NSString *key = [_jobsStats.allKeys objectAtIndex:index];
    FTAPIServerStatsDataObject *s = [_jobsStats objectForKey:key];
    UIColor *sliceColor = s.realColor;
    return sliceColor;
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSlice:(SliceLayer *)sliceLayer withIndex:(NSInteger)index {
    [_chartOverlay setStartAngle:sliceLayer.startAngle];
    [_chartOverlay setEndAngle:sliceLayer.endAngle];
    [_chartOverlay setSliceColor:[self colorForItemAtIndex:index]];
    [_chartOverlay setNeedsDisplay];
    [UIView animateWithDuration:0.15 animations:^{
        [_chartOverlay setAlpha:1];
    }];
}

- (void)handleDelayedDeselection {
    [_chart deselectCurrenSlice];
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index {
    if (index >= _jobsStats.allKeys.count) return;
    NSString *key = [_jobsStats.allKeys objectAtIndex:index];
    FTAPIServerStatsDataObject *s = [_jobsStats objectForKey:key];
    [_countLabel setText:[NSString stringWithFormat:@"%d", s.count]];
    [_descriptionLabel setText:[self titleForCode:[[_jobsStats.allKeys objectAtIndex:index] uppercaseString]]];
    [_countLabel sizeToFit];
    [_countLabel centerHorizontally];
    
    CGAffineTransform t = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [_chartCenter setTransform:t];
    } completion:^(BOOL finished) {
        
    }];
    
    if (_deselectTimer) {
        [_deselectTimer invalidate];
        _deselectTimer = nil;
    }
    _deselectTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(handleDelayedDeselection) userInfo:nil repeats:NO];
}

- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index {
    CGAffineTransform t = CGAffineTransformMakeScale(1.0, 1.0);
    [self showTotalJobs];
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [_chartCenter setTransform:t];
        [_chartOverlay setAlpha:0];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            
        }];
    }];
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return _jobsStats.allKeys.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    NSString *key = [_jobsStats.allKeys objectAtIndex:index];
    FTAPIServerStatsDataObject *s = [_jobsStats objectForKey:key];
    return s.count;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    return [self colorForItemAtIndex:index];
}


@end
