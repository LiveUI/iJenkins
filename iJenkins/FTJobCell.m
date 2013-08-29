//
//  FTJobCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTJobCell.h"


@implementation FTJobCell


#pragma mark Job data object delegate methods

- (void)jobDataObject:(FTAPIJobDataObject *)object didFinishLoadingJobDetail:(FTAPIJobDetailDataObject *)detail {
    [self.detailTextLabel setText:detail.lastBuild.urlString];
}


@end
