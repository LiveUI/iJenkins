//
//  FTLoginAlert.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 10/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTLoginAlert.h"


@interface FTLoginAlert ()

@end


static FTLoginAlertLoginBlock currentLoginBlock;
static FTLoginAlertCancelBlock currentCancelBlock;


@implementation FTLoginAlert


#pragma mark Initialization

+ (FTLoginAlert *)sharedInstance {
    static FTLoginAlert *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[FTLoginAlert alloc] init];
    });
    return shared;
}

#pragma mark Issuing alerts

- (void)showLoginDialogWithLoginBlock:(FTLoginAlertLoginBlock)loginBlock andCancelBlock:(FTLoginAlertCancelBlock)cancelBlock {
    currentLoginBlock = loginBlock;
    currentCancelBlock = cancelBlock;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FTLangGet(@"Please login") message:nil delegate:self cancelButtonTitle:FTLangGet(@"Cancel") otherButtonTitles:FTLangGet(@"Login"), nil];
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [[alert textFieldAtIndex:0] setText:dAccountsManager.selectedAccount.username];
    [[alert textFieldAtIndex:0] setPlaceholder:FTLangGet(@"Username")];
    [alert show];
}

- (void)showLoginDialogWithLoginBlock:(FTLoginAlertLoginBlock)loginBlock andCancelBlock:(FTLoginAlertCancelBlock)cancelBlock accordingToResponseCode:(HTTPCode)responseCode {
    if (responseCode == HTTPCode401Unauthorised || responseCode == HTTPCode403Forbidden) {
        [self showLoginDialogWithLoginBlock:loginBlock andCancelBlock:cancelBlock];
    }
}

#pragma mark Alert view delegate methods

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput && (buttonIndex == 1)) {
        [dAccountsManager.selectedAccount setUsername:[alertView textFieldAtIndex:0].text];
        [dAccountsManager.selectedAccount setPasswordOrToken:[alertView textFieldAtIndex:1].text];
        if (currentLoginBlock) {
            currentLoginBlock(dAccountsManager.selectedAccount.username, dAccountsManager.selectedAccount.passwordOrToken);
        }
    }
    else {
        if (currentCancelBlock) {
            currentCancelBlock();
        }
    }
}


@end
