//
//  FTStandaloneChartVieew.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 01/07/2013.
//  Copyright (c) 2013 Fuerte Innovations All rights reserved.
//

#import "FTStandaloneChartView.h"
#import "FTChartOverlay.h"


@interface FTStandaloneChartView ()

@property (nonatomic, strong) XYPieChart *chart;
@property (nonatomic, strong) UIView *chartCenter;
@property (nonatomic, strong) FTChartOverlay *chartOverlay;
@property (nonatomic, strong, readonly) UILabel *dateLabel;
@property (nonatomic, strong, readonly) UILabel *countLabel;
@property (nonatomic, strong) UILabel *currencyTagLabel;
@property (nonatomic, strong) NSTimer *deselectTimer;
@property (nonatomic, strong) UIView *clickableOverlay;

@end


@implementation FTStandaloneChartView


#pragma mark Data

- (NSString *)colorForItemAtIndex:(NSInteger)index {
    NSArray *arr = @[@"83C966", @"37ACE2", @"5182D2", @"F6A944", @"F5C441"];
    return [arr objectAtIndex:index];
}

- (CGFloat)valueForItemAtIndex:(NSInteger)index {
    NSArray *arr = @[@30, @10, @8, @15, @10];
    return [[arr objectAtIndex:index] floatValue];
}

- (CGFloat)activePositionForItemAtIndex:(NSInteger)index {
    NSArray *arr = @[@185, @275, @365, @455, @545];
    return ([[arr objectAtIndex:index] integerValue] - 90);
}

- (NSString *)titleForItemAtIndex:(NSInteger)index {
    NSArray *arr = @[@"Food", @"Entertainment", @"Rent", @"Holiday", @"Other costs"];
    return [arr objectAtIndex:index];
}

- (NSString *)priceForItemAtIndex:(NSInteger)index {
    NSArray *arr = @[@"£57.20", @"£100.45", @"£81.50", @"£150", @"£100"];
    return [arr objectAtIndex:index];
}

#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 290, 290)];
    if (self) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 280, 280)];
        [v setBackgroundColor:[UIColor colorWithHexString:@"E7E7E7" andAlpha:1]];
        [v.layer setCornerRadius:140];
        [self addSubview:v];
        
        _chart = [[XYPieChart alloc] initWithFrame:CGRectMake(0, 0, 290, 290)];
        [_chart setUserInteractionEnabled:YES];
        [_chart setDataSource:self];
        [_chart setDelegate:self];
        [_chart setStartPieAngle:DegreesToRadians(-90)];
        [_chart setAnimationSpeed:0.8];
        [_chart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
        [_chart setPieCenter:CGPointMake(145, 145)];
        [_chart setLabelShadowColor:[UIColor clearColor]];
        [_chart setSelectedSliceOffsetRadius:11];
        [self addSubview:_chart];
        
        [NSTimer scheduledTimerWithTimeInterval:0.6 target:_chart selector:@selector(reloadData) userInfo:nil repeats:NO];
        
        CGFloat chartWidth = 24;
        _chartCenter = [[UIView alloc] initWithFrame:CGRectMake(chartWidth, chartWidth, (_chart.width - (2 * chartWidth)), (_chart.width - (2 * chartWidth)))];
        [_chartCenter setUserInteractionEnabled:NO];
        [_chartCenter setUserInteractionEnabled:YES];
        [_chartCenter setBackgroundColor:[UIColor whiteColor]];
        [_chartCenter.layer setCornerRadius:(_chartCenter.width / 2)];
        [_chart addSubview:_chartCenter];
        
        _chartOverlay = [[FTChartOverlay alloc] initWithFrame:_chart.bounds];
        [_chartOverlay setUserInteractionEnabled:NO];
        [_chart addSubview:_chartOverlay];
        
        CGFloat cr = 242;
        v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cr, cr)];
        [v setBackgroundColor:[UIColor colorWithHexString:@"E7E7E7" andAlpha:1]];
        [v.layer setCornerRadius:(v.frame.size.width / 2)];
        [_chart addSubview:v];
        [v centerInSuperview];
        
        cr = 232;
        UIView *topWhiteOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cr, cr)];
        [topWhiteOverlay setUserInteractionEnabled:NO];
        [topWhiteOverlay setBackgroundColor:[UIColor whiteColor]];
        [topWhiteOverlay.layer setCornerRadius:(cr / 2)];
        [_chart addSubview:topWhiteOverlay];
        [topWhiteOverlay centerInSuperview];
        
        UIView *copyHolder = [[UIView alloc] initWithFrame:_chartCenter.frame];
        [copyHolder setUserInteractionEnabled:NO];
        [_chart addSubview:copyHolder];
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 110, 250, 22)];
        [_countLabel setUserInteractionEnabled:NO];
        [_countLabel setTextColor:[UIColor colorWithHexString:@"0093E3"]];
        [_countLabel setBackgroundColor:[UIColor clearColor]];
        [_countLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [_countLabel setText:@"£561.30"];
        [copyHolder addSubview:_countLabel];
        [_countLabel sizeToFit];
        [_countLabel centerHorizontally];
        
//        _currencyTagLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 98, 250, 22)];
//        [_currencyTagLabel setUserInteractionEnabled:NO];
//        [_currencyTagLabel setTextColor:[UIColor colorWithHexString:@"4D4D4D"]];
//        [_currencyTagLabel setBackgroundColor:[UIColor clearColor]];
//        [_currencyTagLabel setFont:[UIFont fontWithName:@"TurkcellSatura-Bold" size:14]];
//        [_currencyTagLabel setText:@"TL"];
//        [copyHolder addSubview:_currencyTagLabel];
//        [_currencyTagLabel setXOrigin:(_countLabel.right + 4)];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, (_countLabel.bottom - 70), 252, 22)];
        [_dateLabel setUserInteractionEnabled:NO];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setTextColor:[UIColor colorWithHexString:@"7E7F7F"]];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setFont:[UIFont systemFontOfSize:14]];
        [_dateLabel setText:@"Total spending"];
        [copyHolder addSubview:_dateLabel];
        [_dateLabel centerHorizontally];
    }
    return self;
}

#pragma mark Settings

- (void)showTotalPrice {
    [_countLabel setText:@"£561.20"];
    [_countLabel sizeToFit];
    [_countLabel centerHorizontally];
    [_currencyTagLabel setXOrigin:(_countLabel.right + 4)];
    [_dateLabel setText:@"Total spending"];
}

- (void)setDelegate:(id<FTStandaloneChartViewDelegate>)delegate {
    _delegate = delegate;
    if (!_clickableOverlay) {
        _clickableOverlay = [[UIView alloc] initWithFrame:_chartCenter.frame];
        [_clickableOverlay setBackgroundColor:[UIColor clearColor]];
        [_chart addSubview:_clickableOverlay];
        [_clickableOverlay makeMarginInSuperView:80];
        [_clickableOverlay.layer setCornerRadius:(_clickableOverlay.width / 2)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTheCenterPiece:)];
        [_clickableOverlay addGestureRecognizer:tap];
    }
}

#pragma mark Touch events

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    if (_deselectTimer) {
        [_deselectTimer invalidate];
        _deselectTimer = nil;
    }
    return result;
}

- (void)didTapOnTheCenterPiece:(UITapGestureRecognizer *)recognizer {
    if ([_delegate respondsToSelector:@selector(standaloneChartView:didTapOvViewAtIndex:)]) {
        [_delegate standaloneChartView:self didTapOvViewAtIndex:0];
    }
}

#pragma mark Pie chart delegate & datasource methods

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return 5;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    return [self valueForItemAtIndex:index];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    return [UIColor colorWithHexString:[self colorForItemAtIndex:index]];
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSlice:(SliceLayer *)sliceLayer withIndex:(NSInteger)index {
    [_chartOverlay setStartAngle:sliceLayer.startAngle];
    [_chartOverlay setEndAngle:sliceLayer.endAngle];
    [_chartOverlay setSliceColor:[UIColor colorWithHexString:[self colorForItemAtIndex:index]]];
    [_chartOverlay setNeedsDisplay];
    [UIView animateWithDuration:0.15 animations:^{
        [_chartOverlay setAlpha:1];
    }];
}

- (void)handleDelayedDeselection {
    [_chart deselectCurrenSlice];
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index {
    if (index >= 7) return;
    [_countLabel setText:[self priceForItemAtIndex:index]];
    [_dateLabel setText:[[self titleForItemAtIndex:index] uppercaseString]];
    [_countLabel sizeToFit];
    [_countLabel centerHorizontally];
    [_currencyTagLabel setXOrigin:(_countLabel.right + 4)];
    
    CGAffineTransform t = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [_chartCenter setTransform:t];
    } completion:^(BOOL finished) {
        
    }];
    
    _deselectTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(handleDelayedDeselection) userInfo:nil repeats:NO];
}

- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index {
    CGAffineTransform t = CGAffineTransformMakeScale(1.0, 1.0);
    [self showTotalPrice];
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [_chartCenter setTransform:t];
        [_chartOverlay setAlpha:0];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            
        }];
    }];    
}


@end
