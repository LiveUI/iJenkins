//
//  FTJobDetailViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTJobDetailViewController.h"
#import "FTJobInfoBuildNumberCell.h"
#import "FTSmallTextCell.h"
#import "FTJobHealthInfoCell.h"
#import "FTLastBuildInfoCell.h"


@interface FTJobDetailViewController ()

@end


@implementation FTJobDetailViewController


#pragma mark Creating elements

- (void)createTopButtons {
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:FTLangGet(@"Build Now") style:UIBarButtonItemStylePlain target:self action:@selector(didCLickRunBuildNow:)];
    [self.navigationItem setRightBarButtonItem:edit];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTopButtons];
    [self createTableView];
}

#pragma mark Actions

- (void)didCLickRunBuildNow:(UIBarButtonItem *)sender {
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [ai startAnimating];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithCustomView:ai];
    [self.navigationItem setRightBarButtonItem:edit];
    
    NSString *url = [NSString stringWithFormat:@"%@job/%@/build", [kAccountsManager selectedAccount].baseUrl, [_job.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:8.0];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createTopButtons];
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode >= 400) {
                NSString *message = [NSString stringWithFormat:@"%@ (%@: %d)", FTLangGet(@"We were unable to reach the server, please try again later."), FTLangGet(@"HTTP Error"), statusCode];
                [super showAlertWithTitle:FTLangGet(@"Request error") andMessage:message];
            }
        });
    }];
}

#pragma mark Creating cells

- (UITableViewCell *)cellForJobInfoWithRow:(NSInteger)row {
    switch (row) {
        case 0: {
            FTJobInfoBuildNumberCell *cell = (FTJobInfoBuildNumberCell *)[FTJobInfoBuildNumberCell cellForTable:self.tableView];
            [cell setJob:_job];
            return cell;
        }
            
        case 1: {
            FTSmallTextCell *cell = (FTSmallTextCell *)[FTSmallTextCell cellForTable:self.tableView];
            [cell setText:[NSString stringWithFormat:@"%@ %@ %@ %@ %@", FTLangGet(@"Last build has been executed"), @"14 hour and 15 minutes", FTLangGet(@"ago and took"), @"1 minute and 14 seconds", FTLangGet(@"to finish")]];
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

- (UITableViewCell *)cellForLastBuildsWithRow:(NSInteger)row {
    FTAPIJobDetailBuildDataObject *build = [_job.jobDetail.builds objectAtIndex:row];
    FTLastBuildInfoCell *cell = (FTLastBuildInfoCell *)[FTLastBuildInfoCell cellForTable:self.tableView];
    [cell setBuild:build];
    return cell;
}

#pragma mark Table view delegate & data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return (2 + _job.jobDetail.healthReports.count);
            break;
            
        case 1:
            return (_job.jobDetail.builds.count > 5) ? 5 : _job.jobDetail.builds.count;
            break;
            
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
            
        case 1:
            return [self cellForLastBuildsWithRow:indexPath.row];
            break;
            
        default:
            return [super tableView:tableView cellForRowAtIndexPath:indexPath];
            break;
    }
}


@end
