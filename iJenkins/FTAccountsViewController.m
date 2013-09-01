//
//  FTAccountsViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAccountsViewController.h"
#import "FTNoAccountCell.h"


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
    [_tableView reloadData];
}

#pragma mark Creating elements

- (void)createTableView {
    _data = [kAccountsManager accounts];
    _demoAccount = [kAccountsManager demoAccount];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setAutoresizingWidthAndHeight];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
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
    [c setAccount:[[FTAccount alloc] init]];
    [c setDelegate:self];
    [c setTitle:FTLangGet(@"New Instance")];
    [self.navigationController pushViewController:c animated:YES];
}

- (void)didCLickEditItem:(UIBarButtonItem *)sender {
    [_tableView setEditing:!_tableView.editing animated:YES];
}

#pragma mark Table view delegate and data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? ((_data.count > 0) ? _data.count : 1) : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 44 : 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && _data.count == 0) {
        return 100;
    }
    else {
        return 54;
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FTLangGet(@"Remove");
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
    FTNoAccountCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTNoAccountCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (UITableViewCell *)accountCellForIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"accountCell";
    FTBasicCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTBasicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
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
        if ([_delegate respondsToSelector:@selector(accountsViewController:didSelectAccount:)]) {
            [_delegate accountsViewController:self didSelectAccount:acc];
        }
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    FTAccount *acc = (indexPath.section == 0) ? [_data objectAtIndex:indexPath.row] : _demoAccount;
    FTAddAccountViewController *c = [[FTAddAccountViewController alloc] init];
    [c setDelegate:self];
    [c setTitle:acc.name];
    [c setAccount:acc];
    [self.navigationController pushViewController:c animated:YES];
}

#pragma mark Add account view controller delegate methods

- (void)addAccountViewController:(FTAddAccountViewController *)controller didAddAccount:(FTAccount *)account {
    [self reloadData];
    [self scrollToAccount:account];
}

- (void)addAccountViewController:(FTAddAccountViewController *)controller didModifyAccount:(FTAccount *)account {
    [self reloadData];
    [self scrollToAccount:account];
}


@end
