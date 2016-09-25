//
//  FTPluginDetailViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 10/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTPluginDetailViewController.h"
#import "FTSmallTextCell.h"
#import "FTValueCell.h"


@interface FTPluginDetailViewController ()

@end


@implementation FTPluginDetailViewController


#pragma mark Creating elements

- (void)createTopButtons {
    // TODO: Create option to update the plugin
//    if (_plugin.hasUpdate && NO) {
//        UIBarButtonItem *b = [[UIBarButtonItem alloc] initWithTitle:FTLangGet(@"Update") style:UIBarButtonItemStyleBordered target:self action:@selector(updatePlugin)];
//        [self.navigationItem setRightBarButtonItem:b];
//    }
}

- (void)createAllElements {
    [super createAllElements];
    [super createTableView];
}

#pragma mark Actions

- (void)updatePlugin {
    NSLog(@"Update plugin pyco!");
}

#pragma mark Settings

- (void)setPlugin:(FTAPIPluginManagerPluginDataObject *)plugin {
    _plugin = plugin;
    [self createTopButtons];
    [self.tableView reloadData];
}

#pragma mark Table view delegate & datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 8;
    }
    else {
        return (_plugin.dependencies.count > 0) ? _plugin.dependencies.count : 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    }
    else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? FTLangGet(@"Settings") : FTLangGet(@"Dependencies");
}

- (FTValueCell *)valueCellForKey:(NSString *)key andValue:(NSString *)value {
    FTValueCell *cell = [FTValueCell valueCellForTableView:self.tableView];
    [cell.textLabel setText:key];
    [cell.detailTextLabel setText:value];
    return cell;
}

- (NSArray *)keyValueForRow:(NSInteger)row {
    NSString *yes = FTLangGet(@"Yes");
    NSString *no = FTLangGet(@"No");
    switch (row) {
        case 0:
            return @[@"Name", _plugin.longName];
            break;
            
        case 1:
            return @[@"Identifier", _plugin.shortName];
            break;
            
        case 2:
            return @[@"Version", _plugin.version];
            break;
            
        case 3:
            return @[@"Is enabled", _plugin.enabled ? yes : no];
            break;
            
        case 4:
            return @[@"Downgradable", _plugin.downgradable ? yes : no];
            break;
            
        case 5:
            return @[@"Is active", _plugin.active ? yes : no];
            break;
            
        case 6:
            return @[@"Is deleted", _plugin.deleted ? yes : no];
            break;
            
        case 7:
            return @[@"Is pinned", _plugin.pinned ? yes : no];
            break;
            
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSArray *arr = [self keyValueForRow:indexPath.row];
        return [self valueCellForKey:FTLangGet(arr[0]) andValue:arr[1]];
    }
    else {
        if (_plugin.dependencies.count > 0) {
            FTAPIPluginManagerPluginDependencyDataObject *dep = _plugin.dependencies[indexPath.row];
            FTBasicCell *cell = [FTBasicCell cellForTable:tableView];
            [cell.textLabel setText:dep.shortName];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"Version: %@%@", dep.version, [NSString stringWithFormat:@" (%@)", FTLangGet(dep.optional ? @"Optional" : @"Required")]]];
            return cell;
        }
        else {
            FTSmallTextCell *cell = [FTSmallTextCell smallTextCellForTable:tableView withText:FTLangGet(@"There are no dependencies for this module")];
            return cell;
        }
    }
}


@end
