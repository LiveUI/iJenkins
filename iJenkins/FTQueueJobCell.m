//
//  FTQueueJobCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 10/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTQueueJobCell.h"


@implementation FTQueueJobCell


#pragma mark Data

- (void)fillData {
    [self resetStatusColor];
    BOOL desc = (self.job.executor == nil);
    if (!self.job.jobDetail) {
        if (desc) [self setDescriptionText:FTLangGet(@"Loading ...")];
        [self.buildScoreView setAlpha:0];
        [self.buildIdView setText:@"#?"];
    }
    else {
        if (desc) {
            if (self.job.jobDetail.lastBuild.number == 0) {
                [self setAccessoryType:UITableViewCellAccessoryNone];
                if (desc) [self setDescriptionText:FTLangGet(@"No build has been executed yet")];
            }
            else {
                [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                
                NSString *description = (self.job.jobDetail.healthReport.description.length > 0) ? self.job.jobDetail.healthReport.description : FTLangGet(FT_NA);
                [self setDescriptionText:description];
            }
            [self resetScoreIcon];
            [self.buildIdView setText:[NSString stringWithFormat:@"#%d", self.job.jobDetail.lastBuild.number]];
            
            [UIView animateWithDuration:0.15 animations:^{
                [self.buildScoreView setAlpha:1];
            }];
        }
    }
    if (!desc) {
        [self.detailTextLabel setText:[NSString stringWithFormat:@"%@: %d.0%%", FTLangGet(@"Progress"), self.job.executor.progress]];
    }
}


@end
