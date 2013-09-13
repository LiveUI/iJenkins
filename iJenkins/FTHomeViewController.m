//
//  FTHomeViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTHomeViewController.h"
#import "FTJobDetailViewController.h"
#import "FTLoadingCell.h"
#import "FTJobCell.h"


@interface FTHomeViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) FTAPIJobsDataObject *jobsObject;
@property (nonatomic, strong) NSMutableArray *finalData;

@end


@implementation FTHomeViewController


#pragma mark Data

- (void)loadData {
    if (!_jobsObject) {
        _jobsObject = [[FTAPIJobsDataObject alloc] init];
        [FTAPIConnector connectWithObject:_jobsObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
            _finalData = [NSMutableArray arrayWithArray:_jobsObject.jobs];
            [super.tableView reloadData];
            [self setTitle:kAccountsManager.selectedAccount.name];
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
        
        for (FTAPIJobDataObject *job in _jobsObject.jobs) {
            NSRange isRange = [job.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (isRange.location != NSNotFound) {
                [arr addObject:job];
            }
        }
        _finalData = arr;
    }
    else {
        _finalData = [NSMutableArray arrayWithArray:_jobsObject.jobs];
    }
    [super.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _finalData = [NSMutableArray arrayWithArray:_jobsObject.jobs];
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
    [super.tableView reloadData];
}

#pragma mark Creating elements

- (void)createTableView {
    [super createTableView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, super.tableView.width, 44)];
    [_searchBar setDelegate:self];
    [_searchBar setShowsCancelButton:NO];
    [_searchBar setAutoresizingWidth];
    [super.tableView setTableHeaderView:_searchBar];
}

- (void)createTopButtons {
    UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithTitle:FTLangGet(@"Filter") style:UIBarButtonItemStyleBordered target:self action:@selector(showAccountsViewWithSender:)];
    [self.navigationItem setRightBarButtonItem:filter];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTopButtons];
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

#pragma mark Table view delegate and data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 1 : ((_finalData.count == 0) ? 1 : _finalData.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 200;
    else return 54;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return FTLangGet((section == 0) ? @"Overview" : @"Jobs");
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
    static NSString *identifier = @"cellForOverviewIdentifier";
    FTAccountOverviewCell *cell = [super.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTAccountOverviewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell setDelegate:self];
    [cell setJobsStats:_jobsObject.jobsStats];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && _jobsObject.jobs.count > 0) {
        FTAPIJobDataObject *job = [_finalData objectAtIndex:indexPath.row];
        if (job.jobDetail) {
            FTJobDetailViewController *c = [[FTJobDetailViewController alloc] init];
            [c setTitle:job.name];
            [c setJob:job];
            [self.navigationController pushViewController:c animated:YES];
        }
    }
}

#pragma mark Overview cell delegate methods

- (void)accountOverviewCell:(FTAccountOverviewCell *)cell requiresFilterForStat:(FTAPIJobsStatsDataObject *)stat {
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected filter" message:stat.color delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    //[alert show];
}


@end
