//
//  FTLogViewController.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 04/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTViewController.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface FTLogViewController : FTViewController <MFMailComposeViewControllerDelegate>

- (id)initWithJobName:(NSString *)jobName andBuildNumber:(NSInteger)buildNumber;


@end
