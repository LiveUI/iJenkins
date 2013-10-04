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
#import "FTLogViewController.h"
#import "FTBuildInfoCell.h"
#import "NSDate+Formatting.h"

/**
 *  This enum defines concrete rows of the build detail controller. To reorder informations (cells), just change the order in this enum, change number of rows in const values and corresponding mapping methods -indexForIndexIndexPath and -indexPathForIndex
 */
typedef NS_ENUM(NSUInteger, FTBuildDetailControllerIndex) {
    FTBuildDetailControllerIndexBuildNumber,
    FTBuildDetailControllerIndexDateExecuted,
    FTBuildDetailControllerIndexCause,
    FTBuildDetailControllerIndexDuration,
    FTBuildDetailControllerIndexExpectedDuration,
    FTBuildDetailControllerIndexResult,
    FTBuildDetailControllerIndexBuildLog,
    FTBuildDetailControllerIndexChanges,
    FTBuildDetailControllerIndexBuiltOn,
    FTBuildDetailControllerIndexExecutor,
};


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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 44;
    else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 6;
            break;
            
        case 1:
            return 2;
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return FTLangGet((section == 0) ? @"Build info" : @"Details");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BuildInfoCell";
    
    FTBuildInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[FTBuildInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.layoutType = FTBasicCellLayoutTypeDefault;
    }
    
    FTBuildDetailControllerIndex index = [self indexForIndexPath:indexPath];
    
    cell.textLabel.text = [self titleForIndex:index];
    cell.detailTextLabel.text = [self detailForIndex:index];
    
    BOOL canOpenCell = (indexPath.section == 1);
    if (canOpenCell) {
        if (indexPath.row == 1) {
            canOpenCell = (_build.buildDetail.changeSet.items.count > 0);
        }
        if (!canOpenCell) {
            [cell.textLabel setAlpha:0.3];
            [cell.detailTextLabel setAlpha:0.3];
            [cell.accessoryView setAlpha:0.3];
        }
        else {
            [cell.textLabel setAlpha:1];
            [cell.detailTextLabel setAlpha:1];
            [cell.accessoryView setAlpha:1];
        }
    }
    cell.accessoryType = (canOpenCell  ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FTBuildDetailControllerIndex index = [self indexForIndexPath:indexPath];
    
    UIViewController *openedController = nil;
    
    switch (index)
    {
        case FTBuildDetailControllerIndexBuildLog:
            openedController = [[FTLogViewController alloc] initWithJobName:_build.buildDetail.jobName andBuildNumber:_build.buildDetail.buildNumber];
            break;
            
        case FTBuildDetailControllerIndexChanges: {
            if (_build.buildDetail.changeSet.items.count > 0) {
                FTBuildDetailChangesViewController *c = [[FTBuildDetailChangesViewController alloc] init];
                [c setChangeSet:_build.buildDetail.changeSet];
                openedController = c;
            }
        }
            
        default:
            break;
    }
    
    if (openedController) {
        [self.navigationController pushViewController:openedController animated:YES];
    }
}

#pragma mark - Private methods

- (NSString *)titleForIndex:(FTBuildDetailControllerIndex)index
{
    NSString *title = nil;
    
    switch (index)
    {
        case FTBuildDetailControllerIndexBuildNumber:
            title = FTLangGet(@"Build number");
            break;
        case FTBuildDetailControllerIndexDateExecuted:
            title = FTLangGet(@"Date executed");
            break;
        case FTBuildDetailControllerIndexCause:
            title = FTLangGet(@"Cause");
            break;
        case FTBuildDetailControllerIndexDuration:
            title = FTLangGet(@"Duration");
            break;
        case FTBuildDetailControllerIndexExpectedDuration:
            title = FTLangGet(@"Expected duration");
            break;
        case FTBuildDetailControllerIndexResult:
            title = FTLangGet(@"Result");
            break;
        case FTBuildDetailControllerIndexBuiltOn:
            title = FTLangGet(@"Built on");
            break;
        case FTBuildDetailControllerIndexExecutor:
            title = FTLangGet(@"Executor");
            break;
        case FTBuildDetailControllerIndexBuildLog:
            title = FTLangGet(@"Build log");
            break;
        case FTBuildDetailControllerIndexChanges:
            title = FTLangGet(@"Changes");
            break;
    }
    
    return title;
}

- (NSString *)detailForIndex:(FTBuildDetailControllerIndex)index
{
    NSString *title = nil;

    switch (index)
    {
        case FTBuildDetailControllerIndexBuildNumber:
            title = [NSString stringWithFormat:@"#%d", self.build.number]; // Done
            break;
            
        case FTBuildDetailControllerIndexDateExecuted:
            title = [_build.buildDetail.dateExecuted relativeDate];
            break;
            
        case FTBuildDetailControllerIndexCause:
            title = (_build.buildDetail.causes.count > 0) ? [(FTAPIBuildDetailCauseDataObject *)_build.buildDetail.causes.lastObject shortDescription] : FTLangGet(@"n/a"); // Done
            break;
            
        case FTBuildDetailControllerIndexDuration: {
            NSTimeInterval seconds = (self.build.buildDetail.duration / 1000);
            NSTimeInterval minutes = floor(seconds / 60);
            seconds = round(seconds - (minutes * 60));
            title = [NSString stringWithFormat:@"%.0f %@, %.0f %@", minutes, FTLangGet(@"min"), seconds, FTLangGet(@"sec")];
            break;
        }
        
        case FTBuildDetailControllerIndexExpectedDuration: {
            NSTimeInterval seconds = (self.build.buildDetail.estimatedDuration / 1000);
            NSTimeInterval minutes = floor(seconds / 60);
            seconds = round(seconds - (minutes * 60));
            title = [NSString stringWithFormat:@"%.0f %@, %.0f %@", minutes, FTLangGet(@"min"), seconds, FTLangGet(@"sec")];
            break;
        }
            
        case FTBuildDetailControllerIndexResult:
            title = FTLangGet(_build.buildDetail.resultString.uppercaseString); // Done
            break;
        
        case FTBuildDetailControllerIndexBuiltOn:
            title = @"Build on TODO";
            break;
            
        case FTBuildDetailControllerIndexExecutor:
            title = @"Executor TODO";
            break;
            
        case FTBuildDetailControllerIndexChanges:
            title = [NSString stringWithFormat:@"(%d)", _build.buildDetail.changeSet.items.count];
            break;
            
        default:
            break;
    }
    
    return title;
}

#pragma mark Enum mappings

- (FTBuildDetailControllerIndex)indexForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return indexPath.row;
    }
    else if(indexPath.section == 1) {
        return indexPath.row + [self tableView:self.tableView numberOfRowsInSection:0];
    }
    else {
        return 0;
    }
}

- (NSIndexPath *)indexPathForIndex:(FTBuildDetailControllerIndex)index
{
    NSInteger numberOfItemsInFirstSection = [self tableView:self.tableView numberOfRowsInSection:0];
    
    if (index < numberOfItemsInFirstSection) {
        return [NSIndexPath indexPathForRow:index inSection:0];
    }
    else if (index < numberOfItemsInFirstSection+[self tableView:self.tableView numberOfRowsInSection:1]) {
        return [NSIndexPath indexPathForRow:(index-numberOfItemsInFirstSection) inSection:1];
    }
    else {
        return nil;
    }
}


@end
