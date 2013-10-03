//
//  FTAccountsViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAccountsViewController.h"
#import "FTServerHomeViewController.h"
#import "FTNoAccountCell.h"
#import "FTAccountCell.h"

#import "GCNetworkReachability.h"


@interface FTAccountsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *demoAccounts;

@end


@implementation FTAccountsViewController {
    
    NSMutableDictionary *_runningReachabilityRequests;
    NSMutableDictionary *_serverReachabilityCache;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _runningReachabilityRequests = [NSMutableDictionary dictionary];
        _serverReachabilityCache = [NSMutableDictionary dictionary];
    }
    return self;
}


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
    _demoAccounts = [kAccountsManager demoAccounts];
    
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

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [FTAPIConnector stopLoadingAll];
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
    return (section == 0) ? ((_data.count > 0) ? _data.count : 1) : _demoAccounts.count;
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
    FTAccount *acc = (indexPath.section == 0) ? [_data objectAtIndex:indexPath.row] : [_demoAccounts objectAtIndex:indexPath.row];
    [cell.textLabel setText:acc.name];
    NSString *port = (acc.port != 0) ? [NSString stringWithFormat:@":%d", acc.port] : @"";
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@%@", acc.host, port]];
    
    //  Status of the server
    NSNumber *key = @([acc hash]);
    NSNumber *statusNumber = _serverReachabilityCache[key];
    
    //  Status is already known, set it
    if (statusNumber) {
        cell.reachabilityStatus = [statusNumber unsignedIntegerValue];
    }
    //  Try to get status using reachability
    else {
        //  Set loading status
        cell.reachabilityStatus = FTAccountCellReachabilityStatusLoading;
        _serverReachabilityCache[key] = @(FTAccountCellReachabilityStatusLoading);
        
        //  Start reachability check
        [self _updateServerReachabilityStatus:acc];
    }
    
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
        FTAccount *acc = [self _acccountForIndexPath:indexPath];
        [kAccountsManager setSelectedAccount:acc];
        [FTAPIConnector resetForAccount:acc];
        
        FTServerHomeViewController *c = [[FTServerHomeViewController alloc] init];
        [c setTitle:acc.name];
        [self.navigationController pushViewController:c animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    FTAccount *acc = [self _acccountForIndexPath:indexPath];
    FTAddAccountViewController *c = [[FTAddAccountViewController alloc] init];
    [c setDelegate:self];
    NSLog(@"%@",acc.name);
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
        [controller resetAccountToOriginalStateIfNotNew];
    }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private methods

- (FTAccount *)_acccountForIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0) ? [_data objectAtIndex:indexPath.row] : [_demoAccounts objectAtIndex:indexPath.row];
}

- (NSIndexPath *)_indexPathForAccount:(FTAccount *)account
{
    NSUInteger index = [_data indexOfObject:account];
    
    //  Account is in custom data - user defined account
    if (index != NSNotFound) {
        return [NSIndexPath indexPathForRow:index inSection:0];
    }
    
    //  Demo account
    index = [_demoAccounts indexOfObject:account];
    if (index != NSNotFound) {
        return [NSIndexPath indexPathForRow:index inSection:1];
    }
    
    //  Account not found
    return nil;
}

#pragma mark Server reachability

/**
 Method starts reachability request for the given account (server)
 
 @param account Account (server) which availability should be checked
 */
- (void)_updateServerReachabilityStatus:(FTAccount *)account
{
    //  Start checking reachability of the account server
    //  At the moment, only host is checked as the GCNetworkReachability has some troubles with full URLs with ports
    
    //  Get server URL
    NSString *hostname = account.host;
    
    //  Check the reachability request is not running yet
    if ([_runningReachabilityRequests objectForKey:@([account hash])]) {
        return;
    }
    
    [_runningReachabilityRequests setObject:@(YES) forKey:@([account hash])];
    
    //  Start reachability requests
    GCNetworkReachability *reachability = [GCNetworkReachability reachabilityWithHostName:hostname];
    
    NSDictionary *userInfo = @{
                               @"Reachability": reachability,
                               @"RequestsQueue": _runningReachabilityRequests,
                               @"Account": account
                               };
    
    [reachability startMonitoringNetworkReachabilityWithHandler:^(GCNetworkReachabilityStatus status)
    {
        //  Cancel previous perform request taking care of timeouting
        //  Request is finished so there is no need for timeout handling anymore
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_reachabilityDidTimeout:) object:userInfo];
        
        FTAccountCellReachabilityStatus serverStatus = (status == GCNetworkReachabilityStatusNotReachable ? FTAccountCellReachabilityStatusUnreachable : FTAccountCellReachabilityStatusReachable);
        
        //  Call finish handler
        [self _reachability:reachability forAccount:account didFinishWithStatus:serverStatus];
        
        //  Remove request from cache
        [_runningReachabilityRequests removeObjectForKey:@([account hash])];
    }];
    
    //  Schedule timeout of the reachability request in 5s in case it stays stuck
    [self performSelector:@selector(_reachabilityDidTimeout:) withObject:userInfo afterDelay:5.0];
}

/**
 Callback for reachability status change. This method is called when the reachability finishes its requests or times out.
 Methods takes care of setting new status to cache and reloading the cell row
 
 @param reachability Reachability instance just finished
 @param account      Account of server reachability is checking
 @param status       Final status the servers table view cell should have
 */
- (void)_reachability:(GCNetworkReachability *)reachability forAccount:(FTAccount *)account didFinishWithStatus:(FTAccountCellReachabilityStatus)status
{
#ifdef DEBUG
    NSString *statusName = nil;
    
    switch (status) {
        case FTAccountCellReachabilityStatusUnknown:
            statusName = @"Unknown";
            break;
        case FTAccountCellReachabilityStatusLoading:
            statusName = @"Loading";
            break;
        case FTAccountCellReachabilityStatusUnreachable:
            statusName = @"Unreachable";
            break;
        case FTAccountCellReachabilityStatusReachable:
            statusName = @"Reachable";
            break;
    }
    
    NSLog(@"Reachability request finished. Server \"%@\" is %@", account.host, statusName);
#endif
    
    //  Update status of cell
    NSNumber *key = @([account hash]);
    _serverReachabilityCache[key] = @(status);
    
    //  Get cell and update its appearance
    NSIndexPath *indexPath = [self _indexPathForAccount:account];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

/**
 Method called when the Reachability timeout finishes
 UserInfo:
     @"Reachability": reachability,
     @"RequestsQueue": NSMutableDictionary of running reachability requests,
     @"Account": Account for which the reachability timed-out

 @param userInfo NSDictionary with objects required for method to work
 */
- (void)_reachabilityDidTimeout:(NSDictionary *)userInfo
{
    //  Get objects from user info
    GCNetworkReachability *reachability = userInfo[@"Reachability"];
    NSMutableDictionary *runningRequests = userInfo[@"RequestsQueue"];
    FTAccount *account = userInfo[@"Account"];
    
    //  Finish reachability request
    [reachability stopMonitoringNetworkReachability];
    [runningRequests removeObjectForKey:@([account hash])];
    
    //  Fake finish status with NotReachable state
    [self _reachability:reachability forAccount:account didFinishWithStatus:FTAccountCellReachabilityStatusUnknown];
}

@end
