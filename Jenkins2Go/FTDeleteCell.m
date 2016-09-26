//
//  FTDeleteCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 09/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTDeleteCell.h"


@implementation FTDeleteCell


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setBackgroundColor:[UIColor colorWithHexString:@"FF3824"]];
    [self.textLabel setTextAlignment:NSTextAlignmentCenter];
    [self.textLabel setTextColor:[UIColor whiteColor]];
    [self.textLabel setFont:[UIFont boldSystemFontOfSize:17]];
}

#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
}

#pragma mark Initialization

+ (FTDeleteCell *)deleteCellForTableView:(UITableView *)tableView {
    static NSString *identifier = @"deleteCellIdentifier";
    FTDeleteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTDeleteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.layoutType = FTBasicCellLayoutTypeDefault;
    }
    [cell.textLabel setText:FTLangGet(@"Delete")];
    return cell;
}


@end
