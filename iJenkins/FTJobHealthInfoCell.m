//
//  FTJobHealthInfoCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 12/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTJobHealthInfoCell.h"


@interface FTJobHealthInfoCell ()

@property (nonatomic, strong) UIImageView *buildScoreView;

@end


@implementation FTJobHealthInfoCell


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.textLabel setHidden:YES];
    [self.detailTextLabel setWidth:250];
    [self.detailTextLabel setXOrigin:54];
    [self.detailTextLabel setNumberOfLines:0];
}

#pragma mark Creating elements

- (void)createIcons {
    _buildScoreView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 14, 26, 26)];
    [self addSubview:_buildScoreView];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createIcons];
}

#pragma mark Settings

- (void)setHealth:(FTAPIJobDetailHealthDataObject *)health {
    _health = health;
    [self.detailTextLabel setText:_health.description2];
    NSString *iconName = [NSString stringWithFormat:@"IJ_%@", _health.iconUrl];
    UIImage *img = [UIImage imageNamed:iconName];
    [_buildScoreView setImage:img];
}

#pragma mark Initialization

+ (FTBasicCell *)cellForTable:(UITableView *)tableView {
    static NSString *identifier = @"jobHealthInfoCell";
    FTJobHealthInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTJobHealthInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}


@end
