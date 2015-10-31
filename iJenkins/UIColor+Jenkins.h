//
//  UIColor+Jenkins.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 04/10/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (Jenkins)

+ (UIColor *)colorForJenkinsColorCode:(NSString *)colorCode;
+ (UIColor *)colorForJenkinsBuildStatus:(NSString *)buildStatus;


@end
