//
//  FTServerHomeViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTServerHomeViewController.h"
#import "FTJobDetailViewController.h"
#import "FTLoadingCell.h"
#import "FTJobCell.h"
#import "FTNoJobCell.h"


@interface FTServerHomeViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) FTAccountOverviewCell *overviewCell;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSArray *views;

@property (nonatomic, strong) FTAPIServerViewDataObject *selectedView;

@property (nonatomic, strong) FTAPIServerDataObject *serverObject;
@property (nonatomic, strong) NSMutableArray *finalData;

@property (nonatomic) BOOL isDataAvailable;

@end


@implementation FTServerHomeViewController


#pragma mark Data

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData {
    if (!_serverObject) {
        _serverObject = [[FTAPIServerDataObject alloc] init];
        if (_selectedView) {
            [_serverObject setViewToLoad:_selectedView];
        }
        [FTAPIConnector connectWithObject:_serverObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
            if (error) {
                //[super showAlertWithTitle:FTLangGet(@"Connection error") andMessage:error.localizedDescription];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FTLangGet(@"Connection error") message:error.localizedDescription delegate:self cancelButtonTitle:FTLangGet(@"Ok") otherButtonTitles:nil];
                [alert show];
            }
            else {
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
                _finalData = [NSMutableArray arrayWithArray:_serverObject.jobs];
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
        [self.tableView reloadData];
    }
}

#pragma mark Search bar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 1) {
        NSMutableArray *arr = [NSMutableArray array];
        
        for (FTAPIJobDataObject *job in _serverObject.jobs) {
            NSRange isRange = [job.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (isRange.location != NSNotFound) {
                [arr addObject:job];
            }
        }
        _finalData = arr;
    }
    else {
        _finalData = [NSMutableArray arrayWithArray:_serverObject.jobs];
    }
    [super.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _finalData = [NSMutableArray arrayWithArray:_serverObject.jobs];
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
    [super.tableView reloadData];
}

#pragma mark Creating elements

- (void)createTableView {
    _isDataAvailable = YES;
    
    [super createTableView];
    
    // TODO: Implement search bar
    /*
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, super.tableView.width, 44)];
    [_searchBar setDelegate:self];
    [_searchBar setShowsCancelButton:NO];
    [_searchBar setAutoresizingWidth];
    [super.tableView setTableHeaderView:_searchBar];
    */
     
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
    [c setViews:_views];
    [c setDelegate:self];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
    [self presentViewController:nc animated:YES completion:^{
        
    }];
}

#pragma mark Table view delegate and data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isDataAvailable) {
        return 2;
    }
    else return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isDataAvailable) {
        return (section == 0) ? 1 : ((_finalData.count == 0) ? 1 : _finalData.count);
    }
    else return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isDataAvailable) {
        if (indexPath.section == 0) return 218;
        else return 54;
    }
    else {
        return 100;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_isDataAvailable) {
        return FTLangGet((section == 0) ? @"Overview" : @"Jobs");
    }
    else {
        return FTLangGet(@"Jobs");
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
    FTAPIJobDataObject *job = [_finalData objectAtIndex:indexPath.row];
    [job setDelegate:cell];
    [cell setJob:job];
    [cell.textLabel setText:job.name];
    [cell setDescriptionText:(job.jobDetail.healthReport.description ? job.jobDetail.healthReport.description : FTLangGet(@"Loading ..."))];
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
    static NSString *identifier = @"cellForNoJobIdentifier";
    FTNoJobCell *cell = [super.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTNoJobCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isDataAvailable) {
        if (!_finalData || _finalData.count == 0) {
            return [FTLoadingCell cellForTable:tableView];
        }
        if (indexPath.section == 0) {
            return [self cellForOverview];
        }
        else if (indexPath.section == 1) {
            return [self cellForJobAtIndexPath:indexPath];
        }
        else {
            return nil;
        }
    }
    else {
        return [self cellForNoJob];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isDataAvailable) {
        if (indexPath.section == 1 && _serverObject.jobs.count > 0) {
            FTAPIJobDataObject *job = [_finalData objectAtIndex:indexPath.row];
            if (job.jobDetail) {
                FTJobDetailViewController *c = [[FTJobDetailViewController alloc] init];
                [c setTitle:job.name];
                [c setJob:job];
                [self.navigationController pushViewController:c animated:YES];
            }
        }
    }
    else {
        [self showViewSelector:nil];
    }
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


@end
