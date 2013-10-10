//
//  FTServerHomeViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTServerHomeViewController.h"
#import "FTJobDetailViewController.h"
#import "FTManageViewController.h"
#import "FTBuildQueueViewController.h"
#import "FTBasicCell.h"
#import "FTLoadingCell.h"
#import "FTJobCell.h"
#import "FTNoJobCell.h"
#import "FTIconCell.h"
#import "FTHTTPCodes.h"


@interface FTServerHomeViewController ()

@property (nonatomic, strong) FTAccountOverviewCell *overviewCell;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSArray *views;

@property (nonatomic, strong) FTAPIServerViewDataObject *selectedView;

@property (nonatomic, strong) FTAPIServerDataObject *serverObject;

@property (nonatomic, strong) NSArray *jobs; // All available jobs
@property (nonatomic, strong) NSArray *searchResults; // Filtered search results

@property (nonatomic) BOOL isDataAvailable;

@end


@implementation FTServerHomeViewController


#pragma mark Data

- (void)loadData {
    if (!_serverObject) {
        _isDataAvailable = NO;
        self.searchBar.text = @"";
        
        _serverObject = [[FTAPIServerDataObject alloc] init];
        if (_selectedView) {
            [_serverObject setViewToLoad:_selectedView];
        }
        [FTAPIConnector connectWithObject:_serverObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
            if (error) {
                NSLog(@"Error code: %d", _serverObject.response.statusCode);
                if (_serverObject.response.statusCode == HTTPCode401Unauthorised || _serverObject.response.statusCode == HTTPCode403Forbidden) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FTLangGet(@"Please login") message:nil delegate:self cancelButtonTitle:FTLangGet(@"Cancel") otherButtonTitles:FTLangGet(@"Login"), nil];
                    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
                    [[alert textFieldAtIndex:0] setText:kAccountsManager.selectedAccount.username];
                    [[alert textFieldAtIndex:0] setPlaceholder:FTLangGet(@"Username")];
                    [alert show];
                }
                else if (error.code != -999) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FTLangGet(@"Connection error") message:error.localizedDescription delegate:self cancelButtonTitle:FTLangGet(@"Ok") otherButtonTitles:nil];
                    [alert show];
                }
                else {
                    
                }
            }
            else {
                if (kAccountsManager.selectedAccount.accountType == FTAccountTypeKeychain) {
                    [kAccountsManager updateAccount:kAccountsManager.selectedAccount];
                }
                [_overviewCell setJobsStats:_serverObject.jobsStats];
                if (_serverObject.jobs.count > 0) {
                    _isDataAvailable = YES;
                }
                else {
                    _isDataAvailable = NO;
                }
                if (_serverObject.views && (_serverObject.views.count > 0)) {
                    _views = _serverObject.views;
                }
                
                self.jobs = [NSArray arrayWithArray:_serverObject.jobs];
                [super.tableView reloadData];
                [self setTitle:kAccountsManager.selectedAccount.name];
                
                if (_serverObject.views.count > 1) {
                    if (!_selectedView) {
                        _selectedView = [_views objectAtIndex:0];
                    }
                }
                
                [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(createTopButtons) userInfo:nil repeats:NO];
                [_refreshControl endRefreshing];
            }
        }];
    }
    else {
        _isDataAvailable = YES;
        [self.tableView reloadData];
    }
}

#pragma mark Search bar delegate

- (void)filterSearchResultsWithSearchString:(NSString *)searchString
{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (FTAPIJobDataObject *job in _serverObject.jobs) {
        NSRange isRange = [job.name rangeOfString:searchString options:NSCaseInsensitiveSearch];
        if (isRange.location != NSNotFound) {
            [arr addObject:job];
        }
    }
    self.searchResults = arr;
}

#pragma mark Creating elements

- (void)createTableView {
    [super createTableView];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, super.tableView.width, 44)];

    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    
    [self.tableView setTableHeaderView:self.searchBar];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refreshActionCalled:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshControl];
    [_refreshControl centerHorizontally];
    [_refreshControl setYOrigin:-60];
}

- (void)createTopButtons {
    UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithTitle:_selectedView.name style:UIBarButtonItemStyleBordered target:self action:@selector(showViewSelector:)];
    [self.navigationItem setRightBarButtonItem:filter animated:YES];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTableView];
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super.tableView setContentOffset:CGPointMake(0, _searchBar.height)];
}

#pragma mark Actions

- (void)refreshActionCalled:(UIRefreshControl *)sender {
    _serverObject = nil;
    [self loadData];
}

- (void)showViewSelector:(UIBarButtonItem *)sender {
    FTViewSelectorViewController *c = [[FTViewSelectorViewController alloc] init];
    [c setSelectedView:_selectedView];
    [c setViews:_views];
    [c setDelegate:self];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
    [self presentViewController:nc animated:YES completion:NULL];
}

#pragma mark Table view delegate and data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //  When tableView == self.tableView condition is
    //      - YES: regular content table is asking for its data
    //      - NO: search display controller is asking for data into its table view
    return (tableView == self.tableView ? 2 : 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if ([self isJobsSection:section]) {
            return [self.jobs count];
        }
        else return 3;
    }
    else {
        return [self.searchResults count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        if (!_isDataAvailable) {
            return (indexPath.section == 0 ? ((indexPath.row == 0) ? 218 : 54) : 54);
        }
        if ([self isOverviewSection:indexPath.section]) {
            if (indexPath.row == 0) return 218;
            else return 54;
        }
        else if([self isJobsSection:indexPath.section]) {
            return 54;
        }
        else {
            return 100;
        }
    }
    else {
        return 54;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return ([self isOverviewSection:section] ? FTLangGet(@"Overview") : FTLangGet(@"Jobs"));
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //  Show default header height for content table and no header in search results
    if (tableView == self.tableView) {
        return UITableViewAutomaticDimension;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)cellForJobAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"jobCellIdentifier";
    FTJobCell *cell = [super.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTJobCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        [cell setLayoutType:FTBasicCellLayoutTypeDefault];
    }
    [cell reset];
    
    FTAPIJobDataObject *job = [self jobAtIndexPath:indexPath];
    if (job.jobDetail.lastBuild.number > 0) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    [job setDelegate:cell];
    [cell setJob:job];
    [cell.textLabel setText:job.name];
    return cell;
}

- (UITableViewCell *)cellForJob:(FTAPIJobDataObject *)job
{
    static NSString *identifier = @"jobCellIdentifier";
    FTJobCell *cell = [super.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTJobCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        [cell setLayoutType:FTBasicCellLayoutTypeDefault];
    }
    [cell reset];
    
    if (job.jobDetail.lastBuild.number > 0) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    [job setDelegate:cell];
    [cell setJob:job];
    [cell.textLabel setText:job.name];
    return cell;
}

- (UITableViewCell *)cellForOverview {
    if (_overviewCell) return _overviewCell;
    static NSString *identifier = @"cellForOverviewIdentifier";
    _overviewCell = [super.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!_overviewCell) {
        _overviewCell = [[FTAccountOverviewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [_overviewCell setDelegate:self];
    [_overviewCell setJobsStats:_serverObject.jobsStats];
    return _overviewCell;
}

- (UITableViewCell *)cellForNoJob {
    static NSString *CellIdentifier = @"cellForNoJobIdentifier";
    UITableViewCell *cell = [super.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[FTNoJobCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (FTIconCell *)iconCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cellForSettingsIdentifier";
    FTIconCell *cell = [super.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[FTIconCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 1) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.iconView setDefaultIconIdentifier:@"icon-road"];
        [cell.textLabel setText:FTLangGet(@"Build queue")];
        [cell.detailTextLabel setText:FTLangGet(@"And build executor status")];
    }
    else {
        [cell.iconView setDefaultIconIdentifier:@"icon-cogs"];
        [cell.textLabel setText:FTLangGet(@"Manage Jenkins")];
        // TODO: Decide if the manage section is only for logged in users!
        if ((kAccountsManager.selectedAccount.username && kAccountsManager.selectedAccount.username.length > 0) || YES) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
            [cell.iconView setAlpha:1];
            [cell.textLabel setAlpha:1];
            [cell.detailTextLabel setAlpha:1];
            [cell.detailTextLabel setText:FTLangGet(@"Basic Jenkins configuration")];
        }
        else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.iconView setAlpha:0.4];
            [cell.textLabel setAlpha:0.4];
            [cell.detailTextLabel setAlpha:0.4];
            [cell.detailTextLabel setText:FTLangGet(@"Security needs to be enabled to access this section")];
        }
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        if (_isDataAvailable)
        {
            if ([self isOverviewSection:indexPath.section]) {
                if (indexPath.row == 0) return [self cellForOverview];
                else {
                    return [self iconCellForRowAtIndexPath:indexPath];
                }
            }
            else if ([self.jobs count] == 0) {
                return [self cellForNoJob];
            }
            else {
                return [self cellForJobAtIndexPath:indexPath];
            }
        }
        else {
            return [FTLoadingCell cellForTable:tableView];
        }
    }
    else {
        FTAPIJobDataObject *job = [self jobAtIndexPath:indexPath inTableView:tableView];
        return [self cellForJob:job];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.tableView)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell isKindOfClass:[FTNoJobCell class]]) {
            [self showViewSelector:nil];
            return;
        }
        else if ([cell isKindOfClass:[FTIconCell class]]) {
            //  Dont open anything if there is not disclosure indicator in the cell
            //  This disabled opening "Manage Jenkins" section when the security is not enabled
            if (cell.accessoryType != UITableViewCellAccessoryDisclosureIndicator) {
                return;
            }
            
            if (indexPath.row == 1) {
                FTBuildQueueViewController *c = [[FTBuildQueueViewController alloc] init];
                [self.navigationController pushViewController:c animated:YES];
            }
            else {
                FTManageViewController *c = [[FTManageViewController alloc] init];
                [self.navigationController pushViewController:c animated:YES];
            }
            return;
        }
    }
    
    FTAPIJobDataObject *job = [self jobAtIndexPath:indexPath inTableView:tableView];

    if (job.jobDetail.lastBuild.number > 0) {
        FTJobDetailViewController *c = [[FTJobDetailViewController alloc] init];
        [c setTitle:job.name];
        [c setJob:job];
        [self.navigationController pushViewController:c animated:YES];
    }
}

#pragma mark Search display controller delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterSearchResultsWithSearchString:searchString];
    return YES;
}

#pragma mark Overview cell delegate methods

- (void)accountOverviewCell:(FTAccountOverviewCell *)cell requiresFilterForStat:(FTAPIServerStatsDataObject *)stat {
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected filter" message:stat.color delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    //[alert show];
}

#pragma mark View selector delegate methods

- (void)viewSelectorController:(FTViewSelectorViewController *)controller didSelect:(FTAPIServerViewDataObject *)view {
    _selectedView = view;
    _serverObject = nil;
    [self loadData];
    self.navigationItem.rightBarButtonItem = nil;
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark Alert view delegate methods

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput && (buttonIndex == 1)) {
        [kAccountsManager.selectedAccount setUsername:[alertView textFieldAtIndex:0].text];
        [kAccountsManager.selectedAccount setPasswordOrToken:[alertView textFieldAtIndex:1].text];
        _serverObject = nil;
        [self loadData];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark Private methods

- (BOOL)isOverviewSection:(NSInteger)section
{
    return (section == 0);
}

- (BOOL)isJobsSection:(NSInteger)section
{
    return (section == 1);
}

- (FTAPIJobDataObject *)jobAtIndexPath:(NSIndexPath *)indexPath
{
    return [self jobAtIndexPath:indexPath inTableView:self.tableView];
}

- (FTAPIJobDataObject *)jobAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
    if (!_isDataAvailable) {
        return nil;
    }
    
    NSArray *dataSource = (tableView == self.tableView ? self.jobs : self.searchResults);
    NSUInteger dataCount = [dataSource count];
    
    if (dataCount > 0 && indexPath.row < dataCount) {
        return dataSource[indexPath.row];
    }
    
    return nil;
}


@end
