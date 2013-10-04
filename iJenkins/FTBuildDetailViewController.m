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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 8 : 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return FTLangGet((section == 0) ? @"Build info" : @"Details");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        FTLogViewController *c = [[FTLogViewController alloc] initWithJobName:@"Vi test" andBuildNumber:1];
        [self.navigationController pushViewController:c animated:YES];
    }
    else {
        FTBuildDetailChangesViewController *c = [[FTBuildDetailChangesViewController alloc] init];
        [c setChangeSet:_build.buildDetail.changeSet];
        [self.navigationController pushViewController:c animated:YES];
    }
}

@end
