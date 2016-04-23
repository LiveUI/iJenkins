//
//  FTJobFolderViewController.m
//  iJenkins
//
//  Created by Chandler Huff on 4/23/16.
//  Copyright © 2016 Fuerte Innovations. All rights reserved.
//

#import "FTJobFolderViewController.h"
#import "FTJobDetailViewController.h"
#import "FTManageViewController.h"
#import "FTBuildQueueViewController.h"
#import "FTBasicCell.h"
#import "FTLoadingCell.h"
#import "FTJobCell.h"
#import "FTNoJobCell.h"
#import "FTIconCell.h"
#import "FTLoginAlert.h"


@interface FTJobFolderViewController () <UITableViewDataSource, UITableViewDelegate> {
    FTAPIJobDataObject *_job;
}

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *views;
@property (nonatomic, strong) NSArray *searchResults;

@end

@implementation FTJobFolderViewController

- (id)initWithJob:(FTAPIJobDataObject *)job {
    self = [super init];
    if (self) {
        _job = job;
        self.title = _job.name;
        
    }
    return self;
}

#pragma mark Data

#pragma mark Creating elements

- (void)createTableView {
    [super createTableView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 44)];
    
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    [_searchController setSearchResultsDataSource:self];
    [_searchController setSearchResultsDelegate:self];
    [_searchController setDelegate:self];
    
    [self.tableView setTableHeaderView:_searchBar];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTableView];
}

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super.tableView setContentOffset:CGPointMake(0, _searchBar.height)];
}

#pragma mark Search bar delegate

- (void)filterSearchResultsWithSearchString:(NSString *)searchString {
    NSMutableArray *arr = [NSMutableArray array];
    
    for (FTAPIJobDataObject *job in _job.childJobs) {
        NSRange isRange = [job.name rangeOfString:searchString options:NSCaseInsensitiveSearch];
        if (isRange.location != NSNotFound) {
            [arr addObject:job];
        }
    }
    _searchResults = arr;
}

#pragma mark Table view delegate and data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return [_job.childJobs count];
    }
    else {
        return [_searchResults count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return FTLangGet(@"Jobs");
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
        if (([FTAccountsManager sharedManager].selectedAccount.username && [FTAccountsManager sharedManager].selectedAccount.username.length > 0) || YES) {
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
        if ([_job.childJobs count] == 0) {
            return [self cellForNoJob];
        }
        else {
            return [self cellForJobAtIndexPath:indexPath];
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
        
        if ([cell isKindOfClass:[FTIconCell class]]) {
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
    
    if (job.childJobs.count > 0) {
        FTJobFolderViewController *c = [[FTJobFolderViewController alloc] initWithJob:job];
        [self.navigationController pushViewController:c animated:YES];
    }
    if (job.jobDetail.lastBuild.number > 0) {
        FTJobDetailViewController *c = [[FTJobDetailViewController alloc] init];
        [c setTitle:job.name];
        [c setJob:job];
        [self.navigationController pushViewController:c animated:YES];
    }
}

#pragma mark Search display controller delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterSearchResultsWithSearchString:searchString];
    return YES;
}

#pragma mark Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Private methods

- (FTAPIJobDataObject *)jobAtIndexPath:(NSIndexPath *)indexPath {
    return [self jobAtIndexPath:indexPath inTableView:self.tableView];
}

- (FTAPIJobDataObject *)jobAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    NSArray *dataSource = (tableView == self.tableView ? _job.childJobs : _searchResults);
    NSUInteger dataCount = [dataSource count];
    
    if (dataCount > 0 && indexPath.row < dataCount) {
        return dataSource[indexPath.row];
    }
    
    return nil;
}

@end
