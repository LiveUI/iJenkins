//
//  FTChartOverlay.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 13/06/2013.
//  Copyright (c) 2013 Ridiculous Innovations All rights reserved.
//

#import "FTView.h"


@interface FTChartOverlay : FTView

@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat endAngle;
@property (nonatomic, strong) UIColor *sliceColor;


@end
