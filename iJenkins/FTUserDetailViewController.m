//
//  FTUserDetailViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTUserDetailViewController.h"
#import "FTDeleteCell.h"
#import "FTValueCell.h"


#define FTUserDetailViewControllerVarCheck(var)                          (_isLoading ? @"Loading ..." : (var && ![var isKindOfClass:[NSNull class]]) ? var : FT_NA)


@interface FTUserDetailViewController ()

@property (nonatomic, readonly) FTAPIUserDetailDataObject *userObject;
@property (nonatomic, readonly) BOOL isLoading;

@end


@implementation FTUserDetailViewController


#pragma mark Data

- (void)loadData {
    _isLoading = YES;
    _userObject = [[FTAPIUserDetailDataObject alloc] initWithNickName:_nickName];
    [FTAPIConnector connectWithObject:_userObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
        _isLoading = NO;
        [self.tableView reloadData];
        
        if ([self canSendMail]) {
            [self createActionButton];
        }
    }];
}

- (NSDictionary *)keyValueForIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return @{@"key": @"Full name", @"value": FTUserDetailViewControllerVarCheck(_userObject.fullName)};
            break;
            
        case 1:
            return @{@"key": @"Nick name", @"value": FTUserDetailViewControllerVarCheck(_nickName)};
            break;
            
        case 2:
            return @{@"key": @"Description", @"value":FTUserDetailViewControllerVarCheck(_userObject.userDescription)};
            break;
            
        case 3:
            return @{@"key": @"Email", @"value": FTUserDetailViewControllerVarCheck(_userObject.emailAddress)};
            break;
            
        default:
            return nil;
            break;
    }
}

- (BOOL)canSendMail {
    return ([MFMailComposeViewController canSendMail] && _userObject.emailAddress && ![_userObject.emailAddress isKindOfClass:[NSNull class]] && (_userObject.emailAddress.length > 3));
}

#pragma mark Creating elements

- (void)createActionButton {
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sendEmail)];
    [self.navigationItem setRightBarButtonItem:share animated:YES];
}

- (void)createAllElements {
    [super createAllElements];
    [super createTableView];
}

#pragma mark Settings

- (void)setNickName:(NSString *)nickName {
    _nickName = nickName;
    [self loadData];
}

#pragma mark Actions

- (void)sendEmail {
    if ([self canSendMail]) {
        MFMailComposeViewController *c = [[MFMailComposeViewController alloc] init];
        [c setToRecipients:@[[NSString stringWithFormat:@"%@ <%@>", _userObject.fullName, _userObject.emailAddress]]];
        [c setMailComposeDelegate:self];
        [c setMessageBody:[NSString stringWithFormat:@"\n\n\n%@", FTLangGet(@"With LOVE from iJenkins for iOS")] isHTML:NO];
        [self presentViewController:c animated:YES completion:^{
            
        }];
    }
}

#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    _isLoading = YES;
}

#pragma mark Tableview delegate & datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (_isLoading || [_nickName isEqualToString:kAccountsManager.selectedAccount.username]) ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 4 : (_isLoading ? 0 : 1);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return FTLangGet((section == 0) ? @"User info" : @"Manage");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        FTValueCell *cell = [FTValueCell valueCellForTableView:tableView];
        NSDictionary *d = [self keyValueForIndexPath:indexPath];
        [cell.textLabel setText:FTLangGet(d[@"key"])];
        [cell.detailTextLabel setText:FTLangGet(d[@"value"])];
        return cell;
    }
    else {
        FTDeleteCell *cell = [FTDeleteCell deleteCellForTableView:tableView];
        [cell.textLabel setText:FTLangGet(@"Delete user")];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 3 && _userObject.emailAddress && ![_userObject.emailAddress isKindOfClass:[NSNull class]]) {
        [self sendEmail];
    }
    else if (indexPath.section == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FTLangGet(@"Confirmation") message:FTLangGet(@"Are you sure you want to delete this user?") delegate:self cancelButtonTitle:FTLangGet(@"Cancel") otherButtonTitles:FTLangGet(@"Delete"), nil];
        [alert show];
    }
}

#pragma mark Alert view delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [_userObject setAction:FTAPIUserDetailDataObjectActionDelete];
        [FTAPIConnector connectWithObject:_userObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
            // TODO: Improve error handling
//            if (!error) {
                if ([_delegate respondsToSelector:@selector(userDetailViewController:didDeleteUser:)]) {
                    [_delegate userDetailViewController:self didDeleteUser:_userObject];
                }
                [self.navigationController popViewControllerAnimated:YES];
//            }
//            else {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FTLangGet(@"Error") message:FTLangGet(@"Unable to delete user") delegate:nil cancelButtonTitle:FTLangGet(@"Ok") otherButtonTitles:nil];
//                [alert show];
//            }
        }];
    }
}

#pragma mark Mail delegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:^{
        // TODO: Create global sliding notification system and inform user about the action when view is dissmissed
        if (result == MFMailComposeResultSent) {
            
        }
        else if (result == MFMailComposeResultFailed) {
            
        }
        else if (result == MFMailComposeResultSaved) {
            
        }
        else if (result == MFMailComposeResultCancelled) {
            
        }
    }];
}


@end
