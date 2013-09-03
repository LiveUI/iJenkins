//
//  FTLoadingCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 02/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTLoadingCell.h"


@implementation FTLoadingCell


#pragma mark Initialization

+ (UITableViewCell *)cellForTable:(UITableView *)tableView {
    static NSString *identifier = @"loadingCellIdentifier";
    FTLoadingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTLoadingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel setTextAlignment:NSTextAlignmentCenter];
}

#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
    
    [self.textLabel setText:FTLangGet(@"Loading ...")];
}


@end
