//
//  FTJobCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTJobCell.h"


@interface FTJobCell ()

@property (nonatomic, strong) UIView *statusColorView;
@property (nonatomic, strong) UIImageView *buildScoreView;
@property (nonatomic, strong) UILabel *buildIdView;

@end


@implementation FTJobCell


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
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

#pragma mark Settings

- (void)resetStatusColor {
    if ([_job.color isEqualToString:@"red"]) {
        [_statusColorView setBackgroundColor:[UIColor colorWithHexString:@"FF4000"]];
    }
    else if ([_job.color isEqualToString:@"blue"]) {
        [_statusColorView setBackgroundColor:[UIColor colorWithHexString:@"0076FF"]];
    }
    else if ([_job.color isEqualToString:@"blue_anime"]) {
        [_statusColorView setBackgroundColor:[UIColor colorWithHexString:@"0076FF"]];
    }
    else if ([_job.color isEqualToString:@"yellow"]) {
        [_statusColorView setBackgroundColor:[UIColor colorWithHexString:@"FFDC73"]];
    }
    else if ([_job.color isEqualToString:@"aborted"]) {
        [_statusColorView setBackgroundColor:[UIColor grayColor]];
    }
    else if ([_job.color isEqualToString:@"disabled"]) {
        [_statusColorView setBackgroundColor:[UIColor darkGrayColor]];
    }
    else if ([_job.color isEqualToString:@"notbuilt"]) {
        [_statusColorView setBackgroundColor:[UIColor lightGrayColor]];
    }
    else  {
        [_statusColorView setBackgroundColor:[UIColor colorWithHexString:@"FF99FF"]];
    }
}

- (void)resetScoreIcon {
    NSString *iconName = [NSString stringWithFormat:@"IJ_%@", _job.jobDetail.healthReport.iconUrl];
    [_buildScoreView setImage:[UIImage imageNamed:iconName]];
}

- (void)setJob:(FTAPIJobDataObject *)job {
    _job = job;
    [self resetStatusColor];
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
    [self.detailTextLabel setText:text];
}

#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}

#pragma mark Job data object delegate methods

- (void)jobDataObject:(FTAPIJobDataObject *)object didFinishLoadingJobDetail:(FTAPIJobDetailDataObject *)detail {
    [self setDescriptionText:detail.healthReport.description];
    [self resetScoreIcon];
    [_buildIdView setText:[NSString stringWithFormat:@"#%d", detail.lastBuild.number]];
}


@end
