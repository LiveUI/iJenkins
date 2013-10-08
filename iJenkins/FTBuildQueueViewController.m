//
//  FTBuildQueueViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 07/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTBuildQueueViewController.h"
#import "FTJobDetailViewController.h"
#import "FTLoadingCell.h"
#import "FTSmallTextCell.h"
#import "FTJobCell.h"


@interface FTBuildQueueViewController ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSArray *queue;
@property (nonatomic) BOOL isLoadingQueue;

@property (nonatomic, strong) NSArray *computers;
@property (nonatomic) BOOL isLoadingComputers;

@end


@implementation FTBuildQueueViewController


#pragma Data

- (void)checkLoading {
    if (!_isLoadingQueue && !_isLoadingComputers) {
        [_refreshControl endRefreshing];
    }
}

- (void)loadData {
    _isLoadingQueue = YES;
    FTAPIBuildQueueDataObject *queueObject = [[FTAPIBuildQueueDataObject alloc] init];
    [FTAPIConnector connectWithObject:queueObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
        _queue = queueObject.items;
        _isLoadingQueue = NO;
        [self.tableView reloadData];
        [self checkLoading];
        if (_queue.count > 10) {
            [self createExecutorLink];
        }
    }];
    
    _isLoadingComputers = YES;
    FTAPIComputerObject *buildsObject = [[FTAPIComputerObject alloc] init];
    [FTAPIConnector connectWithObject:buildsObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
        _computers = buildsObject.computers;
        _isLoadingComputers = NO;
        [self.tableView reloadData];
        [self checkLoading];
    }];
}

#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    [self setTitle:FTLangGet(@"Build queue")];
}

#pragma mark Creating elements

- (void)createTableView {
    [super createTableView];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refreshActionCalled:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshControl];
    [_refreshControl centerHorizontally];
    [_refreshControl setYOrigin:-60];
}

- (void)createExecutorLink {
    UIBarButtonItem *ste = [[UIBarButtonItem alloc] initWithTitle:FTLangGet(@"Executors") style:UIBarButtonItemStyleBordered target:self action:@selector(scrollToExecutorSection:)];
    [self.navigationItem setRightBarButtonItem:ste animated:YES];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTableView];
    
    [self loadData];
}

#pragma mark Actions

- (void)refreshActionCalled:(UIRefreshControl *)sender {
    [self loadData];
}

- (void)scrollToExecutorSection:(UIBarButtonItem *)sender {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark Tableview delegate & datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (_computers.count + 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return (_queue.count == 0) ? 1 : _queue.count;
    }
    else {
        FTAPIComputerInfoObject *computer = _computers[(section - 1)];
        return (computer.executors.count == 0) ? 1 : computer.executors.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return FTLangGet(@"Build queue");
    FTAPIComputerInfoObject *executor = (FTAPIComputerInfoObject *)_computers[(section - 1)];
    NSString *executorName = [NSString stringWithFormat:@"%@: %@", FTLangGet(@"Executor"), [executor displayName]];
    if (executor.offline) {
        executorName = [NSString stringWithFormat:@"%@ (%@)", executorName, FTLangGet(@"Offline")];
    }
    return executorName;
}

- (UITableViewCell *)cellForNoJob {
    static NSString *identifier = @"cellForNoJobIdentifier";
    FTSmallTextCell *cell = [super.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTSmallTextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell.detailTextLabel setText:FTLangGet(@"No builds in the queue")];
    return cell;
}

- (FTBasicCell *)cellForNonActiveExecutorAtIndex:(NSInteger)index {
    static NSString *identifier = @"nonActiveExecutorCellIdentifier";
    FTBasicCell *cell = [super.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTBasicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell.textLabel setText:FTLangGet(@"Idle")];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@: #%d", FTLangGet(@"Executor id"), (index + 1)]];
    return cell;
}

- (FTBasicCell *)cellForEmptyExecutors {
    static NSString *identifier = @"emptyExecutorsCellIdentifier";
    FTSmallTextCell *cell = [super.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTSmallTextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell.detailTextLabel setText:FTLangGet(@"No executors on this computer")];
    return cell;
}

- (UITableViewCell *)cellForJobAtIndexPath:(NSIndexPath *)indexPath {
    FTAPIJobDataObject *job = nil;
    if (indexPath.section == 0) {
        job = [(FTAPIBuildQueueItemDataObject *)_queue[indexPath.row] task];
    }
    else {
        FTAPIComputerInfoObject *computer = _computers[(indexPath.section - 1)];
        if (computer.executors.count == 0) {
            return [self cellForEmptyExecutors];
        }
        FTAPIComputerExecutorObject *executor = computer.executors[indexPath.row];
        if ([executor isKindOfClass:[NSNull class]]) {
            return [self cellForNonActiveExecutorAtIndex:indexPath.row];
        }
        else {
            job = executor.currentExecutable;
        }
    }
    
    static NSString *identifier = @"jobCellIdentifier";
    FTJobCell *cell = [super.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTJobCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        [cell setLayoutType:FTBasicCellLayoutTypeDefault];
    }
    [cell reset];
    
    [job setDelegate:cell];
    [cell setJob:job];
    [cell.textLabel setText:job.name];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_isLoadingQueue) {
            return [FTLoadingCell cellForTable:tableView];
        }
        else {
            if (_queue.count == 0) {
                return [self cellForNoJob];
            }
            else {
                return [self cellForJobAtIndexPath:indexPath];
            }
        }
    }
    else {
        if (_isLoadingComputers) {
            return [FTLoadingCell cellForTable:tableView];
        }
        else {
            if (_computers.count == 0) {
                return [self cellForNoJob];
            }
            else {
                return [self cellForJobAtIndexPath:indexPath];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FTAPIJobDataObject *job = nil;
    if (indexPath.section == 0) {
        if (_queue.count == 0) {
            return;
        }
        job = [(FTAPIBuildQueueItemDataObject *)_queue[indexPath.row] task];
    }
    else {
        FTAPIComputerInfoObject *computer = _computers[(indexPath.section - 1)];
        if (computer.executors.count == 0) {
            return;
        }
        FTAPIComputerExecutorObject *executor = computer.executors[indexPath.row];
        if ([executor isKindOfClass:[NSNull class]]) {
            return;
        }
        else {
            job = executor.currentExecutable;
        }
    }
    if (!job.jobDetail) {
        return;
    }
    
    FTJobDetailViewController *c = [[FTJobDetailViewController alloc] init];
    [c setTitle:job.name];
    [c setJob:job];
    [self.navigationController pushViewController:c animated:YES];
}


@end
