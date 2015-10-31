//
//  FTManageViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 07/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTManageViewController.h"
#import "FTIconCell.h"
#import "FTAPIRestartDataObject.h"
#import "FTLoginAlert.h"


@interface FTManageViewController ()
#if TARGET_OS_IOS || (TARGET_OS_IPHONE && !TARGET_OS_TV)
<UIAlertViewDelegate>
#endif

@property (nonatomic, strong) NSArray *data;

@end


@implementation FTManageViewController


#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    [self setTitle:FTLangGet(@"Manage Jenkins")];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ManageJenkinsTemplate" ofType:@"plist"];
    _data = [NSArray arrayWithContentsOfFile:path];
}

#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
    [super createTableView];
}

#pragma mark Tableview delegate & datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self itemsAtSection:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [(NSDictionary *)_data[section] objectForKey:@"title"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cellForManagementIdentifier";
    FTIconCell *cell = [super.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[FTIconCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    BOOL ok = ([FTAccountsManager sharedManager].selectedAccount.username && [FTAccountsManager sharedManager].selectedAccount.username.length > 0);
    NSDictionary *d = [self itemAtIndexPath:indexPath];
    if (![d[@"loginRequired"] boolValue]) {
        ok = YES;
    }
#if (TARGET_IPHONE_SIMULATOR)
    ok = YES;
#endif
    if (ok) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.iconView setAlpha:1];
        [cell.textLabel setAlpha:1];
        [cell.detailTextLabel setAlpha:1];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [cell.detailTextLabel setText:FTLangGet(d[@"description"])];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.iconView setAlpha:0.4];
        [cell.textLabel setAlpha:0.4];
        [cell.detailTextLabel setAlpha:0.4];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.detailTextLabel setText:FTLangGet(@"Security needs to be enabled to access this section")];
    }
    [cell.textLabel setText:FTLangGet(d[@"name"])];
    [cell.iconView setDefaultIconIdentifier:d[@"icon"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType != UITableViewCellAccessoryDisclosureIndicator) {
        return;
    }
    
    NSDictionary *d = [self itemAtIndexPath:indexPath];
    NSString *controllerString = d[@"controller"];
    NSString *actionString = d[@"action"];
    
    //  If controller value is present, open the controller by name
    if ([controllerString length] > 0) {
        Class class = NSClassFromString(controllerString);
        if (class) {
            FTViewController *c = (FTViewController *)[[class alloc] init];
            [c setTitle:FTLangGet(d[@"name"])];
            if (c) {
                [self.navigationController pushViewController:c animated:YES];
            }
        }
    }
    //  If action value is provided, this is an action
    else if([actionString length] > 0) {
        FTAPIRestartDataObjectType actionType = [FTAPIRestartDataObject typeWithString:actionString];
#if TARGET_OS_IOS || (TARGET_OS_IPHONE && !TARGET_OS_TV)
        
        NSString *message = [NSString stringWithFormat:FTLangGet(@"Are you sure you want to %@ Jenkins?"), cell.textLabel.text];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:cell.textLabel.text message:message delegate:self cancelButtonTitle:FTLangGet(@"Cancel") otherButtonTitles:FTLangGet(@"Confirm"), nil];
        alert.tag = actionType;
        [alert show];
#elif TARGET_OS_TV
        [self performManagementAction:actionType];
#endif
    }
    
}

#pragma mark UIAlertView delegate

#if TARGET_OS_IOS || (TARGET_OS_IPHONE && !TARGET_OS_TV)
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex]) {
        [self performManagementAction:alertView.tag];
    }
}
#endif

#pragma mark Helper methods

- (NSDictionary *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items = [self itemsAtSection:indexPath.section];
    
    return (indexPath.row < [items count] ? items[indexPath.row] : nil);
}

- (NSArray *)itemsAtSection:(NSInteger)section
{
    if (section >= [_data count]) {
        return nil;
    }
    
    return [(NSDictionary *)_data[section] objectForKey:@"items"];
}

- (void)performManagementAction:(FTAPIRestartDataObjectType)actionType
{
    FTAPIRestartDataObject *apiObject = [[FTAPIRestartDataObject alloc] initWithRestartType:actionType];
    [[FTAPIConnector sharedConnector] connectWithObject:apiObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
        if (error) {
            [dFTLoginAlert showLoginDialogWithLoginBlock:^(NSString *username, NSString *password) {
                [self performManagementAction:actionType];
            } andCancelBlock:^{
                
            } accordingToResponseCode:apiObject.response.statusCode];
        }
    }];
}

@end
