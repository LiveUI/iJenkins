//
//  FTManageNodesViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 07/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTManageNodesViewController.h"
#import "FTNodeCell.h"
#import "FTSmallTextCell.h"
#import "NSString+Conversions.h"


@interface FTManageNodesViewController ()

@property (nonatomic, strong) NSArray *computers;

@end


@implementation FTManageNodesViewController


#pragma Data

- (void)loadData {
    FTAPIComputerObject *buildsObject = [[FTAPIComputerObject alloc] init];
    [FTAPIConnector connectWithObject:buildsObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
        _computers = buildsObject.computers;
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
    
    [self createTableView];
    
    [self loadData];
}

#pragma mark Table view delegate & datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _computers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    FTAPIComputerInfoObject *computer = _computers[section];
    return (computer.offline) ? 1 : 7;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    FTAPIComputerInfoObject *executor = (FTAPIComputerInfoObject *)_computers[section];
    NSString *executorName = [NSString stringWithFormat:@"%@: %@", FTLangGet(@"Executor"), [executor displayName]];
    if (executor.offline) {
        executorName = [NSString stringWithFormat:@"%@ (%@)", executorName, FTLangGet(@"Offline")];
    }
    return executorName;
}

- (FTBasicCell *)cellForOfflineNodes {
    static NSString *identifier = @"emptyOfflineNodeCellIdentifier";
    FTSmallTextCell *cell = [super.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTSmallTextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell.detailTextLabel setText:FTLangGet(@"Node is currently offline")];
    return cell;
}

- (FTBasicCell *)cellForInfoAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"infoIdentifier";
    FTNodeCell *cell = [super.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTNodeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    FTAPIComputerInfoObject *computer = _computers[indexPath.section];
    switch (indexPath.row) {
        case 0: {
            [cell.textLabel setText:FTLangGet(@"Executors")];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d", computer.executors.count]];
            break;
        }
            
        case 1: {
            [cell.textLabel setText:FTLangGet(@"Architecture")];
            [cell.detailTextLabel setText:computer.monitorData[@"hudson.node_monitors.ArchitectureMonitor"]];
            break;
        }
            
        case 2: {
            [cell.textLabel setText:FTLangGet(@"Response time")];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d", [computer.monitorData[@"hudson.node_monitors.ResponseTimeMonitor"][@"average"] integerValue]]];
            break;
        }
            
        case 3: {
            NSString *available = [NSString formatFilesize:[computer.monitorData[@"hudson.node_monitors.SwapSpaceMonitor"][@"availableSwapSpace"] doubleValue]];
            NSString *total = [NSString formatFilesize:[computer.monitorData[@"hudson.node_monitors.SwapSpaceMonitor"][@"totalSwapSpace"] doubleValue]];
            [cell.textLabel setText:FTLangGet(@"Swap memory")];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ %@ %@", available, FTLangGet(@"of"), total]];
            break;
        }
            
        case 4: {
            NSString *available = [NSString formatFilesize:[computer.monitorData[@"hudson.node_monitors.SwapSpaceMonitor"][@"availablePhysicalMemory"] doubleValue]];
            NSString *total = [NSString formatFilesize:[computer.monitorData[@"hudson.node_monitors.SwapSpaceMonitor"][@"totalPhysicalMemory"] doubleValue]];
            [cell.textLabel setText:FTLangGet(@"Physical memory")];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ %@ %@", available, FTLangGet(@"of"), total]];
            break;
        }
            
        case 5: {
            NSString *available = [NSString formatFilesize:[computer.monitorData[@"hudson.node_monitors.TemporarySpaceMonitor"][@"size"] doubleValue]];
            [cell.textLabel setText:FTLangGet(@"Temporary space")];
            [cell.detailTextLabel setText:available];
            break;
        }
            
        case 6: {
            NSString *available = [NSString formatFilesize:[computer.monitorData[@"hudson.node_monitors.DiskSpaceMonitor"][@"size"] doubleValue]];
            [cell.textLabel setText:FTLangGet(@"Total disk space")];
            [cell.detailTextLabel setText:available];
            break;
        }
            
        default:
            break;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FTAPIComputerInfoObject *computer = _computers[indexPath.section];
    if (computer.offline) {
        return [self cellForOfflineNodes];
    }
    else {
        return [self cellForInfoAtIndexPath:indexPath];
    }
}



@end
