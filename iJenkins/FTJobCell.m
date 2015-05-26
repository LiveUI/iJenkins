//
//  FTJobCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTJobCell.h"


@interface FTJobCell ()

@end


@implementation FTJobCell


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.textLabel setWidth:200];
    [self.textLabel setXOrigin:(self.textLabel.xOrigin + 60)];
    [self.detailTextLabel setWidth:200];
    [self.detailTextLabel setXOrigin:(self.detailTextLabel.xOrigin + 60)];
}

#pragma mark Creating elements

- (void)createIcons {
    _statusColorView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 14, 14)];
    [_statusColorView.layer setCornerRadius:(_statusColorView.height / 2)];
    [self addSubview:_statusColorView];
    
    _buildScoreView = [[UIImageView alloc] initWithFrame:CGRectMake((_statusColorView.right + 10), 10, 14, 14)];
    [self addSubview:_buildScoreView];
}

- (void)createBuildIdView {
    _buildIdView = [[UILabel alloc] initWithFrame:CGRectMake(10, (54 - 10 - 10), (_buildScoreView.right - 10), 10)];
    [_buildIdView setTextColor:[UIColor grayColor]];
    [_buildIdView setFont:[UIFont systemFontOfSize:10]];
    [_buildIdView setTextAlignment:NSTextAlignmentLeft];
    [_buildIdView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_buildIdView];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createIcons];
    [self createBuildIdView];
}

#pragma mark Animations

- (void)animate {
    if (_job.animating) {
//        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
//            [_statusColorView setAlpha:0];
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
//                [_statusColorView setAlpha:1];
//            } completion:^(BOOL finished) {
//                [self animate];
//            }];
//        }];
    }
    else {
        [_statusColorView setAlpha:1];
    }
}

#pragma mark Settings

- (void)reset {
    
}

- (void)resetStatusColor {
    [_statusColorView setBackgroundColor:[_job realColor]];
    [self animate];
}

- (void)resetScoreIcon {
    NSString *iconName = [NSString stringWithFormat:@"IJ_%@", _job.jobDetail.healthReport.iconUrl];
    UIImage *img = [UIImage imageNamed:iconName];
    [_buildScoreView setImage:img];
}

- (void)setJob:(FTAPIJobDataObject *)job {
    _job = job;
    [self fillData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self resetStatusColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self resetStatusColor];
}

- (void)setDescriptionText:(NSString *)text {
    text = [text stringByReplacingOccurrencesOfString:@"Build stability: " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"Test Result: " withString:@""];
    [self.detailTextLabel setText:text];
}

- (void)fillData {
    [self resetStatusColor];
    if (!_job.jobDetail) {
        [self setDescriptionText:FTLangGet(@"Loading ...")];
        [_buildScoreView setAlpha:0];
        [_buildIdView setText:@"#?"];
    }
    else {
        if (_job.jobDetail.lastBuild.number == 0) {
            [self setAccessoryType:UITableViewCellAccessoryNone];
            [self setDescriptionText:FTLangGet(@"No build has been executed yet")];
        }
        else {
            [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            NSString *description = (_job.jobDetail.healthReport.desc.length > 0) ? _job.jobDetail.healthReport.desc : FTLangGet(FT_NA);
            [self setDescriptionText:FTLangGet(description)];
        }
        [self resetScoreIcon];
        [_buildIdView setText:[NSString stringWithFormat:@"#%ld", (long)_job.jobDetail.lastBuild.number]];
        
        [UIView animateWithDuration:0.15 animations:^{
            [_buildScoreView setAlpha:1];
        }];
    }
}

#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}

#pragma mark Job data object delegate methods

- (void)jobDataObject:(FTAPIJobDataObject *)object didFinishLoadingJobDetail:(FTAPIJobDetailDataObject *)detail {
    [self fillData];
}


@end
