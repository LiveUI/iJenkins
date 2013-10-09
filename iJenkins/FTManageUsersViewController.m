//
//  FTManageUsersViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 07/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTManageUsersViewController.h"
#import "FTSmallTextCell.h"
#import "FTLoadingCell.h"


@interface FTManageUsersViewController ()

@property (nonatomic, strong) NSArray *users;
@property (nonatomic) BOOL isLoading;

@end


@implementation FTManageUsersViewController


#pragma mark Data

- (void)loadData {
    _isLoading = YES;
    FTAPIUsersDataObject *usersObject = [[FTAPIUsersDataObject alloc] init];
    [FTAPIConnector connectWithObject:usersObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
        _users = usersObject.users;
        _isLoading = NO;
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
    [self.tableView reloadData];
}

#pragma mark Table view delegate & datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (_users.count > 0) ? _users.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (FTBasicCell *)userCellForIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"userCellIdentifier";
    FTBasicCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[FTBasicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    FTAPIUsersInfoDataObject *info = _users[indexPath.row];
    NSString *name = nil;
    if ([info.fullName isEqualToString:info.nickName]) {
        name = info.fullName;
    }
    else if (info.fullName.length < 2) {
        name = info.nickName;
    }
    else {
        name = [NSString stringWithFormat:@"%@ (%@)", info.fullName, info.nickName];
    }
    [cell.textLabel setText:name];
    if (info.project) {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@: %@", FTLangGet(@"Last project"), info.project.name]];
    }
    else {
        [cell.detailTextLabel setText:FTLangGet(@"There is no last project for this user")];
    }
    return cell;
}

- (FTBasicCell *)emptyTableCell {
    static NSString *CellIdentifier = @"emptyTableIdentifier";
    FTSmallTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[FTSmallTextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    [cell.detailTextLabel setText:FTLangGet(@"No users available")];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_users.count > 0) {
        return [self userCellForIndexPath:indexPath];
    }
    else {
        if (_isLoading) {
            UITableViewCell *cell = [FTLoadingCell cellForTable:tableView];
            [cell.detailTextLabel setText:FTLangGet(@"This could take a while ... sorry ... :(")];
            return cell;
        }
        else {
            return [self emptyTableCell];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_users.count > 0) {
        FTAPIUsersInfoDataObject *info = _users[indexPath.row];
        FTUserDetailViewController *c = [[FTUserDetailViewController alloc] init];
        [c setDelegate:self];
        [c setTitle:info.nickName];
        [c setNickName:info.nickName];
        [self.navigationController pushViewController:c animated:YES];
    }
}

#pragma mark User detail conroller delegate methods

- (void)userDetailViewController:(FTUserDetailViewController *)controller didDeleteUser:(FTAPIUserDetailDataObject *)user {
    NSMutableArray *arr = [_users mutableCopy];
    for (FTAPIUsersInfoDataObject *info in arr) {
        if ([info.nickName isEqualToString:user.nickName]) {
            [arr removeObject:info];
            break;
        }
    }
    _users = [arr copy];
}


@end
