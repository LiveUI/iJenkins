//
//  UIView+Tools.m
//  PublishTheNews
//
//  Created by Ondrej Rafaj on 20/02/2011.
//  Copyright 2011 PublishTheNews.com. All rights reserved.
//

#import "UIView+Effects.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIView (Effects)


- (void)addShadowWithOffsetSize:(CGSize)offset withColor:(UIColor *)color andOpacity:(CGFloat)opacity {
    self.layer.shadowColor = [color CGColor];
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = offset.height;
    self.layer.shouldRasterize = YES;    
}

- (void)addShadowWithOffset:(CGFloat)offset withColor:(UIColor *)color andOpacity:(CGFloat)opacity {
    [self addShadowWithOffsetSize:CGSizeMake(offset, offset) withColor:color andOpacity:opacity];
}

- (void)addShadow {
    [self addShadowWithOffset:2.0f withColor:[UIColor blackColor] andOpacity:0.4f];
}

- (void)addRedShadow {
    [self addShadowWithOffset:2.0f withColor:[UIColor redColor] andOpacity:0.8f];
}

- (UIImage *)captureImage {
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return viewImage;
}

- (void)shakeViewWithOffset:(CGFloat)offset withCycleDuration:(NSTimeInterval)duration andRepeatCount:(int)repeatCount {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
	[animation setDuration:duration];
	[animation setRepeatCount:repeatCount];
	[animation setAutoreverses:YES];
	[animation setFromValue:[NSValue valueWithCGPoint:CGPointMake([self center].x - offset, [self center].y)]];
	[animation setToValue:[NSValue valueWithCGPoint:CGPointMake([self center].x + offset, [self center].y)]];
	[[self layer] addAnimation:animation forKey:@"position"];
}

- (void)shakeViewWithOffset:(CGFloat)offset andRepeatCount:(int)repeatCount {
	[self shakeViewWithOffset:offset withCycleDuration:0.05 andRepeatCount:repeatCount];
}

- (void)shakeViewWithOffset:(CGFloat)offset {
	[self shakeViewWithOffset:offset andRepeatCount:8];
}

- (void)shakeView {
	[self shakeViewWithOffset:8.0f];
}


@end
