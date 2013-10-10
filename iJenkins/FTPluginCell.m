//
//  FTPluginCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 10/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTPluginCell.h"


@implementation FTPluginCell


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

#pragma mark Settings

- (void)setPlugin:(FTAPIPluginManagerPluginDataObject *)plugin {
    _plugin = plugin;
    
    [self.textLabel setText:plugin.longName];
    [self.detailTextLabel setText:[NSString stringWithFormat:@"%@ (%@)", plugin.shortName, plugin.version]];
}

#pragma mark Initialization

+ (FTPluginCell *)pluginCellForTableView:(UITableView *)tableView withPlugin:(FTAPIPluginManagerPluginDataObject *)plugin {
    static NSString *identifier = @"pluginCellIdentifier";
    FTPluginCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTPluginCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell setPlugin:plugin];
    return cell;
}


@end
