//
//  FTManageUsersViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 07/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTManageUsersViewController.h"
#import "FTBasicCell.h"


@interface FTManageUsersViewController ()

@property (nonatomic, strong) NSArray *users;

@end


@implementation FTManageUsersViewController


#pragma mark Data

- (void)loadData {
    FTAPIUsersDataObject *usersObject = [[FTAPIUsersDataObject alloc] init];
    [FTAPIConnector connectWithObject:usersObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
        _users = usersObject.users;
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
    return _users.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"userCellIdentifier";
    FTBasicCell *cell = [super.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[FTBasicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    FTAPIUsersInfoDataObject *info = _users[indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@%@", info.nickName, ((info.fullName.length > 1) ? [NSString stringWithFormat:@" (%@)", info.fullName] : @"")]];
    if (info.project) {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@: %@", FTLangGet(@"Last project"), info.project.name]];
    }
    else {
        [cell.detailTextLabel setText:FTLangGet(@"There is no last project for this user")];
    }
    return cell;
}


@end
