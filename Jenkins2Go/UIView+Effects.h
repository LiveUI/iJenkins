//
//  UIView+Tools.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 20/02/2011.
//  Copyright 2011 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIView (Effects)

- (void)addShadowWithOffsetSize:(CGSize)offset withColor:(UIColor *)color andOpacity:(CGFloat)opacity;
- (void)addShadowWithOffset:(CGFloat)offset withColor:(UIColor *)color andOpacity:(CGFloat)opacity;
- (void)addRedShadow;
- (void)addShadow;

- (UIImage *)captureImage;

- (void)shakeViewWithOffset:(CGFloat)offset withCycleDuration:(NSTimeInterval)duration andRepeatCount:(int)repeatCount;
- (void)shakeViewWithOffset:(CGFloat)offset andRepeatCount:(int)repeatCount;
- (void)shakeViewWithOffset:(CGFloat)offset;
- (void)shakeView;


@end
