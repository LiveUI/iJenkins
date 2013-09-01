//
//  FTHomeViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTHomeViewController.h"
#import "FTJobDetailViewController.h"
#import "FTJobCell.h"


@interface FTHomeViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *finalData;

@end


@implementation FTHomeViewController


#pragma mark Data

- (void)loadData {
    FTAPIJobsDataObject *jobsObject = [[FTAPIJobsDataObject alloc] init];
    [FTAPIConnector connectWithObject:jobsObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
        NSLog(@"Jobs: %@", jobsObject.jobs);
        _data = jobsObject.jobs;
        _finalData = [NSMutableArray arrayWithArray:_data];
        [_tableView reloadData];
    }];
}

#pragma mark Creating elements

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setAutoresizingWidthAndHeight];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
}

- (void)createTopButtons {
    UIBarButtonItem *accounts = [[UIBarButtonItem alloc] initWithTitle:FTLangGet(@"Accounts") style:UIBarButtonItemStyleBordered target:self action:@selector(showAccountsViewWithSender:)];
    [self.navigationItem setLeftBarButtonItem:accounts];
    
//    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(didCLickEditItem:)];
//    [self.navigationItem setRightBarButtonItem:edit];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTopButtons];
    [self createTableView];
    
    [self setTitle:@"iJenkins"];
}

#pragma mark View lifecycle

- (void)showAccountsViewWithSender:(id)sender {
    FTAccountsViewController *c = [[FTAccountsViewController alloc] init];
    [c setDelegate:self];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:c];
    [nc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:nc animated:(sender != nil) completion:^{
        
    }];
}

- (void)showAccountsView {
    [self showAccountsViewWithSender:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!kAccountsManager.selectedAccount) {
        [self showAccountsView];
    }
}

#pragma mark Account selector delegate methods

- (void)accountsViewController:(FTAccountsViewController *)controller didSelectAccount:(FTAccount *)account {
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self loadData];
}

#pragma mark Table view delegate and data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 1 : _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 44 : 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return FTLangGet((section == 0) ? @"Overview" : @"Jobs");
}

- (UITableViewCell *)cellForJobAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellIdentifier";
    FTJobCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTJobCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        [cell setLayoutType:FTBasicCellLayoutTypeDefault];
    }
    FTAPIJobDataObject *job = [_data objectAtIndex:indexPath.row];
    [job setDelegate:cell];
    [cell setJob:job];
    [cell.textLabel setText:job.name];
    [cell setDescriptionText:(job.jobDetail.healthReport.description ? job.jobDetail.healthReport.description : FTLangGet(@"Loading ..."))];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self cellForJobAtIndexPath:indexPath];
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
    
    if (indexPath.section == 1) {
        FTAPIJobDataObject *job = [_data objectAtIndex:indexPath.row];
        FTJobDetailViewController *c = [[FTJobDetailViewController alloc] init];
        [c setTitle:job.name];
        [c setJob:job];
        [self.navigationController pushViewController:c animated:YES];
    }
}


@end
