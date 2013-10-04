//
//  FTBuildDetailViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 12/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTBuildDetailViewController.h"
#import "FTLogViewController.h"
#import "FTBuildDetailChangesViewController.h"


@interface FTBuildDetailViewController ()

@end


@implementation FTBuildDetailViewController


#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
    
    [self createTableView];
}

#pragma mark Table view delegate & data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return FTLangGet(@"Build details");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FTLogViewController *c = [[FTLogViewController alloc] initWithJobName:_build.buildDetail.jobName andJobNumber:_build.buildDetail.buildNumber];
    [self.navigationController pushViewController:c animated:YES];
}

@end
