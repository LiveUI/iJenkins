//
//  FTChartOverlay.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 13/06/2013.
//  Copyright (c) 2013 Ridiculous Innovations All rights reserved.
//

#import "FTChartOverlay.h"


@implementation FTChartOverlay


#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

#pragma mark Drawing

- (void)drawSliceOfPie:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth {
    //draw arc
    CGPoint center = CGPointMake(self.bounds.size.height / 2, self.bounds.size.width / 2);
    UIBezierPath *arc = [UIBezierPath bezierPath]; //empty path
    [arc setLineWidth:lineWidth];
    [arc moveToPoint:center];
    CGPoint next;
    next.x = center.x + radius * cos(startAngle);
    next.y = center.y + radius * sin(startAngle);
    [arc addLineToPoint:next]; //go one end of arc
    
    [arc addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES]; //add the arc
    [arc addLineToPoint:center]; //back to center
    
    [fillColor set];
    [arc fill];
    [strokeColor set];
    [arc stroke];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    [[UIColor clearColor] set];
    CGContextFillRect(context, (CGRect){CGPointZero, rect.size});
    
    [self drawSliceOfPie:(self.width / 2) startAngle:_startAngle endAngle:_endAngle fillColor:_sliceColor strokeColor:[UIColor clearColor] lineWidth:0];
}

@end
