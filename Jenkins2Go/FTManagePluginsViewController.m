//
//  FTManagePluginsViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 07/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTManagePluginsViewController.h"
#import "FTPluginDetailViewController.h"
#import "FTPluginCell.h"


@interface FTManagePluginsViewController ()

@property (nonatomic, strong) NSArray *plugins;

@end


@implementation FTManagePluginsViewController


#pragma mark Data

- (void)loadData {
    FTAPIPluginManagerDataObject *pluginObject = [[FTAPIPluginManagerDataObject alloc] init];
    [FTAPIConnector connectWithObject:pluginObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
        _plugins = pluginObject.plugins;
        [self.tableView reloadData];
    }];
}

#pragma mark Initialization

- (void)setupView {
    [super setupView];
}

#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
    [super createTableView];
    
    [self loadData];
}

#pragma mark Table view delegate & datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _plugins.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FTAPIPluginManagerPluginDataObject *plugin = _plugins[indexPath.row];
    FTPluginCell *cell = [FTPluginCell pluginCellForTableView:tableView withPlugin:plugin];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FTAPIPluginManagerPluginDataObject *plugin = _plugins[indexPath.row];
    FTPluginDetailViewController *c = [[FTPluginDetailViewController alloc] init];
    [c setTitle:plugin.longName];
    [c setPlugin:plugin];
    [self.navigationController pushViewController:c animated:YES];
}


@end
