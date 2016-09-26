//
//  FTPluginCell.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 10/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTBasicCell.h"


@interface FTPluginCell : FTBasicCell

@property (nonatomic, strong) FTAPIPluginManagerPluginDataObject *plugin;

+ (FTPluginCell *)pluginCellForTableView:(UITableView *)tableView withPlugin:(FTAPIPluginManagerPluginDataObject *)plugin;


@end
