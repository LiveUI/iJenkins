//
//  FTPluginCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 10/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTPluginCell.h"
#import "FAImageView.h"


@interface FTPluginCell ()

@property (nonatomic, readonly) UILabel *statusLabel;
@property (nonatomic, readonly) FAImageView *enabledIcon;

@end


@implementation FTPluginCell


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
    [self.detailTextLabel sizeToFit];
    [_enabledIcon setOrigin:CGPointMake(self.textLabel.xOrigin, (self.detailTextLabel.yOrigin + 1.5))];
    [self.detailTextLabel setXOrigin:(_enabledIcon.right + 4)];
    [_statusLabel sizeToFit];
    [_statusLabel setOrigin:CGPointMake(self.detailTextLabel.right, self.detailTextLabel.yOrigin)];
}

#pragma mark Creating elements

- (void)createStatusLabel {
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_statusLabel setTextColor:[UIColor colorWithHexString:@"007EF3"]];
    [_statusLabel setBackgroundColor:[UIColor clearColor]];
    [_statusLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:_statusLabel];
}

- (void)createIcons {
    _enabledIcon = [[FAImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    [_enabledIcon setImage:nil];
    [_enabledIcon.defaultView setBackgroundColor:[UIColor clearColor]];
    [_enabledIcon.defaultView setTextColor:[UIColor colorWithHexString:@"6C6C6C"]];
    [self addSubview:_enabledIcon];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createStatusLabel];
    [self createIcons];
}

#pragma mark Settings

- (void)setPlugin:(FTAPIPluginManagerPluginDataObject *)plugin {
    _plugin = plugin;
    
    [self.textLabel setText:plugin.longName];
    BOOL noteAvailable = plugin.hasUpdate;
    [self.detailTextLabel setText:[NSString stringWithFormat:@"%@ (%@)%@", plugin.shortName, plugin.version, (noteAvailable ? @" - " : @"")]];
    [_statusLabel setText:(plugin.hasUpdate ? FTLangGet(@"Update available") : @"")];
    [_enabledIcon setDefaultIconIdentifier:(plugin.enabled ? @"icon-ok-circle" : @"icon-ban-circle")];
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
