//
//  FTJobDetailViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTJobDetailViewController.h"
#import "FTBuildDetailViewController.h"
#import "FTJobInfoBuildNumberCell.h"
#import "FTSmallTextCell.h"
#import "FTJobHealthInfoCell.h"
#import "FTLastBuildInfoCell.h"
#import "FTAccountsManager.h"
#import "FTLoginAlert.h"
#import "NSDate+Formatting.h"


@interface FTJobDetailViewController ()

@end


@implementation FTJobDetailViewController


#pragma mark Creating elements

- (void)createBuildNowButton {
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:FTLangGet(@"Build Now") style:UIBarButtonItemStylePlain target:self action:@selector(didCLickRunBuildNow:)];
    [self.navigationItem setRightBarButtonItem:edit];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createBuildNowButton];
    [self createTableView];
}

#pragma mark Data

- (void)buildThis {
    FTAPIJobBuildDataObject *buildObject = [[FTAPIJobBuildDataObject alloc] initWithJobName:_job.name];
    [FTAPIConnector connectWithObject:buildObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
        [self createBuildNowButton];
        if (error) {
            [dFTLoginAlert showLoginDialogWithLoginBlock:^(NSString *username, NSString *password) {
                [self buildThis];
            } andCancelBlock:^{
                
            } accordingToResponseCode:buildObject.response.statusCode];
        }
    }];
}

#pragma mark Actions

- (void)didCLickRunBuildNow:(UIBarButtonItem *)sender {
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [ai startAnimating];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithCustomView:ai];
    [self.navigationItem setRightBarButtonItem:edit];
    
    [self buildThis];
}

#pragma mark Creating cells

- (UITableViewCell *)cellForJobInfoWithRow:(NSInteger)row {
    switch (row) {
        case 0: {
            return [self cellForLastBuildsWithRow:[NSIndexPath indexPathForItem:0 inSection:0]];
        }
            
        case 1: {
            FTSmallTextCell *cell = (FTSmallTextCell *)[FTSmallTextCell smallTextCellForTable:self.tableView withText:nil];
            
            if (_job.jobDetail.builds.count > 0) {
                FTAPIJobDetailBuildDataObject *build = [_job.jobDetail.builds objectAtIndex:0];
                if (!_job.jobDetail.lastBuild.buildDetail) {
                    [build loadBuildDetailWithSuccessBlock:^(FTAPIBuildDetailDataObject *data) {
                        [_job.jobDetail.lastBuild loadBuildDetailWithSuccessBlock:^(FTAPIBuildDetailDataObject *data) {
                            [self.tableView reloadData];
                        } forJobName:_job.name];
                    } forJobName:_job.name];
                }
                else {
                    NSDate *lastBuild = [NSDate dateWithTimeIntervalSince1970:(_job.jobDetail.lastBuild.buildDetail.timestamp / 1)];
                    NSTimeInterval seconds = (_job.jobDetail.lastBuild.buildDetail.duration / 1000);
                    NSTimeInterval minutes = floor(seconds / 60);
                    seconds = round(seconds - (minutes * 60));
                    [cell setText:[NSString stringWithFormat:@"%@ %@ %@ %@ %@", FTLangGet(@"Last build has been executed"), [lastBuild relativeDate], FTLangGet(@"and took"), [NSString stringWithFormat:@"%.0f %@, %.0f %@", minutes, FTLangGet(@"min"), seconds, FTLangGet(@"sec")], FTLangGet(@"to finish")]];
                }
            }
            else {
                [cell setText:FTLangGet(@"This job has never been built")];
            }
            return cell;
        }
            
        default: {
            row -= 2;
            FTAPIJobDetailHealthDataObject *health = [_job.jobDetail.healthReports objectAtIndex:row];
            FTJobHealthInfoCell *cell = (FTJobHealthInfoCell *)[FTJobHealthInfoCell cellForTable:self.tableView];
            [cell setHealth:health];
            return cell;
        }
    }
}

- (UITableViewCell *)cellForLastBuildsWithRow:(NSIndexPath *)indexPath {
    FTLastBuildInfoCell *cell = (FTLastBuildInfoCell *)[FTLastBuildInfoCell cellForTable:self.tableView];
    FTAPIJobDetailBuildDataObject *build = [_job.jobDetail.builds objectAtIndex:indexPath.row];
    if (!build.buildDetail) {
        [build loadBuildDetailWithSuccessBlock:^(FTAPIBuildDetailDataObject *data) {
            [self.tableView reloadData];
        } forJobName:_job.name];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    [cell setBuild:build];
    return cell;
}

#pragma mark Table view delegate & data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return (2 + _job.jobDetail.healthReports.count);
            break;
            
        case 1: {
            NSInteger limit = [[FTAccountsManager sharedManager] selectedAccount].loadMaxItems;
            if (limit == 0) {
                limit = INT_MAX;
            }
            return ((_job.jobDetail.builds.count - 1) > limit) ? limit : (_job.jobDetail.builds.count - 1);
            break;
        }
            
        default:
            return 6;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return FTLangGet(@"Job info");
            break;
            
        case 1:
            return FTLangGet(@"Build history");
            break;
            
        case 2:
            return FTLangGet(@"Build overview");
            break;
            
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return [self cellForJobInfoWithRow:indexPath.row];
            break;
            
        case 1: {
            NSIndexPath *ip = [NSIndexPath indexPathForItem:(indexPath.row + 1) inSection:indexPath.section];
            return [self cellForLastBuildsWithRow:ip];
            break;
        }
            
        default:
            return [super tableView:tableView cellForRowAtIndexPath:indexPath];
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ((indexPath.section == 0 && indexPath.row == 0) || indexPath.section == 1) {
        FTAPIJobDetailBuildDataObject *build = [_job.jobDetail.builds objectAtIndex:(indexPath.row + indexPath.section)];
        if (build.buildDetail) {
            FTBuildDetailViewController *c = [[FTBuildDetailViewController alloc] init];
            [c setTitle:[NSString stringWithFormat:@"%@ #%d", FTLangGet(@"Build"), build.number]];
            [c setBuild:build];
            [self.navigationController pushViewController:c animated:YES];
        }
    }
}


@end
