//
//  UIColor+Tools.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 7.6.10.
//  Copyright 2010 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIColor (Tools)

+ (UIColor *)colorWithRealRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)colorWithRealRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIColor *)randomColor;
+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (UIColor *)alphaPatternImageColorWithSquareSide:(CGFloat)side withColor1:(UIColor *)color1 andColor2:(UIColor *)color2;
+ (UIColor *)alphaPatternImageColorWithSquareSide:(CGFloat)side;
+ (UIColor *)alphaPatternImageColor;


@end
