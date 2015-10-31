//
//  FTValueCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 09/10/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTValueCell.h"


@implementation FTValueCell


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
}

#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
}

#pragma mark Initialization

+ (FTValueCell *)valueCellForTableView:(UITableView *)tableView {
    static NSString *identifier = @"valueCellIdentifier";
    FTValueCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTValueCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.layoutType = FTBasicCellLayoutTypeDefault;
    }
    return cell;
}


@end
