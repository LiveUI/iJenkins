//
//  FTAccountsViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAccountsViewController.h"
#import "FTHomeViewController.h"
#import "FTNoAccountCell.h"
#import "FTAccountCell.h"


@interface FTAccountsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) FTAccount *demoAccount;

@end


@implementation FTAccountsViewController


#pragma mark Layout

- (void)scrollToAccount:(FTAccount *)account {
    
}

#pragma mark Data

- (void)reloadData {
    [super.tableView reloadData];
}

#pragma mark Creating elements

- (void)createTableView {
    _data = [kAccountsManager accounts];
    _demoAccount = [kAccountsManager demoAccount];
    
    [super createTableView];
}

- (void)createTopButtons {
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didCLickAddItem:)];
    [self.navigationItem setLeftBarButtonItem:add];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didCLickEditItem:)];
    [self.navigationItem setRightBarButtonItem:edit];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTableView];
    [self createTopButtons];
    
    [self setTitle:FTLangGet(@"Servers")];
}

#pragma mark Actions

- (void)didCLickAddItem:(UIBarButtonItem *)sender {
    FTAddAccountViewController *c = [[FTAddAccountViewController alloc] init];
    [c setIsNew:YES];
    FTAccount *acc = [[FTAccount alloc] init];
    [c setAccount:acc];
    [c setDelegate:self];
    [c setTitle:FTLangGet(@"New Instance")];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
    [self presentViewController:nc animated:YES completion:^{
        
    }];
}

- (void)didCLickEditItem:(UIBarButtonItem *)sender {
    [super.tableView setEditing:!super.tableView.editing animated:YES];
}

#pragma mark Table view delegate and data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? ((_data.count > 0) ? _data.count : 1) : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && _data.count == 0) {
        return 100;
    }
    else {
        return 54;
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return FTLangGet((section == 0) ? @"Your accounts" : @"Demo account");
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0 && _data.count == 0) || indexPath.section) {
        return NO;
    }
    else return (indexPath.section == 0);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        FTAccount *acc = [_data objectAtIndex:indexPath.row];
        [kAccountsManager removeAccount:acc];
        [tableView reloadData];
    }
}

- (UITableViewCell *)cellForNoAccount {
    static NSString *identifier = @"noAccountCell";
    FTNoAccountCell *cell = [super.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTNoAccountCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (UITableViewCell *)accountCellForIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"accountCell";
    FTAccountCell *cell = [super.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTAccountCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
    }
    if (indexPath.section == 0) {
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    FTAccount *acc = (indexPath.section == 0) ? [_data objectAtIndex:indexPath.row] : _demoAccount;
    [cell.textLabel setText:acc.name];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@:%d", acc.host, acc.port]];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && _data.count == 0) {
        return [self cellForNoAccount];
    }
    else {
        return [self accountCellForIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && _data.count == 0) {
        [self didCLickAddItem:nil];
    }
    else {
        FTAccount *acc = (indexPath.section == 0) ? [_data objectAtIndex:indexPath.row] : _demoAccount;
        [kAccountsManager setSelectedAccount:acc];
        [FTAPIConnector resetForAccount:acc];
        
        FTHomeViewController *c = [[FTHomeViewController alloc] init];
        [self.navigationController pushViewController:c animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    FTAccount *acc = (indexPath.section == 0) ? [_data objectAtIndex:indexPath.row] : _demoAccount;
    FTAddAccountViewController *c = [[FTAddAccountViewController alloc] init];
    [c setDelegate:self];
    [c setTitle:acc.name];
    [c setAccount:acc];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
    [self presentViewController:nc animated:YES completion:^{
        
    }];
}

#pragma mark Add account view controller delegate methods

- (void)addAccountViewController:(FTAddAccountViewController *)controller didAddAccount:(FTAccount *)account {
    [kAccountsManager addAccount:account];
    [self reloadData];
    [self scrollToAccount:account];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)addAccountViewController:(FTAddAccountViewController *)controller didModifyAccount:(FTAccount *)account {
    [kAccountsManager updateAccount:account];
    [self reloadData];
    [self scrollToAccount:account];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)addAccountViewControllerCloseWithoutSave:(FTAddAccountViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
