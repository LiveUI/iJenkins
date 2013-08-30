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
    _statusColorView = [[UIView alloc] initWithFrame:CGRectMake(10, 13, 28, 28)];
    [_statusColorView.layer setCornerRadius:(_statusColorView.height / 2)];
    
    [self addSubview:_statusColorView];
}

- (void)createBuildIdView {
    
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
    else if ([_job.color isEqualToString:@"gray"]) {
        [_statusColorView setBackgroundColor:[UIColor grayColor]];
    }
    else if ([_job.color isEqualToString:@"notbuilt"]) {
        [_statusColorView setBackgroundColor:[UIColor lightGrayColor]];
    }
    else  {
        [_statusColorView setBackgroundColor:[UIColor orangeColor]];
    }
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

#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
}

#pragma mark Job data object delegate methods

- (void)jobDataObject:(FTAPIJobDataObject *)object didFinishLoadingJobDetail:(FTAPIJobDetailDataObject *)detail {
    [self.detailTextLabel setText:detail.lastBuild.urlString];
}


@end
