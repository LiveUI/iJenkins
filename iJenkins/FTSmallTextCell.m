//
//  FTSmallTextCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 12/09/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTSmallTextCell.h"


@interface FTSmallTextCell ()

@property (nonatomic) CGFloat celHeight;

@end


@implementation FTSmallTextCell


#pragma mark Layout

- (CGFloat)cellHeight {
    return 44;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.detailTextLabel setFont:[UIFont systemFontOfSize:[[FTTheme sharedTheme] smallTextCellTitleSize]]];
    [self.detailTextLabel setNumberOfLines:0];
    [self.detailTextLabel setYOrigin:0];
    [self.detailTextLabel setHeight:54];
    [self.detailTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
}

#pragma mark Settings

- (void)setText:(NSString *)text {
    _text = text;
    [self.detailTextLabel setText:_text];
}

#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
}

#pragma mark Initialization

+ (FTSmallTextCell *)smallTextCellForTable:(UITableView *)tableView withText:(NSString *)text {
    static NSString *identifier = @"smallTextCell";
    FTSmallTextCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTSmallTextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell setText:text];
    return cell;
}


@end
