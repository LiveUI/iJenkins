//
//  FTManageViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 07/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTManageViewController.h"
#import "FTIconCell.h"


@interface FTManageViewController ()

@property (nonatomic, strong) NSArray *data;

@end


@implementation FTManageViewController


#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    [self setTitle:FTLangGet(@"Manage Jenkins")];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ManageJenkinsTemplate" ofType:@"plist"];
    _data = [NSArray arrayWithContentsOfFile:path];
}

#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
    [super createTableView];
}

#pragma mark Tableview delegate & datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cellForManagementIdentifier";
    FTIconCell *cell = [super.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[FTIconCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    NSDictionary *d = _data[indexPath.row];
    [cell.textLabel setText:FTLangGet(d[@"name"])];
    [cell.detailTextLabel setText:FTLangGet(d[@"description"])];
    [cell.iconView setDefaultIconIdentifier:d[@"icon"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *d = _data[indexPath.row];
    NSString *controllerString = d[@"controller"];
    Class class = NSClassFromString(controllerString);
    if (class) {
        FTViewController *c = (FTViewController *)[[class alloc] init];
        [c setTitle:FTLangGet(d[@"name"])];
        if (c) {
            [self.navigationController pushViewController:c animated:YES];
        }
    }
}


@end
