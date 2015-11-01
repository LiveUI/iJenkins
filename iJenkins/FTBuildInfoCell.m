//
//  FTBuildInfoCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 04/10/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTBuildInfoCell.h"


@implementation FTBuildInfoCell


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.detailTextLabel setFont:[UIFont systemFontOfSize:[[FTTheme sharedTheme] smallTextCellTitleSize]]];
}


@end
