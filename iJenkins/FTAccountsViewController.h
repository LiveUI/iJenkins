//
//  FTAccountsViewController.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAddAccountViewController.h"


@class FTAccountsViewController, FTAccount;

@protocol FTAccountsViewControllerDelegate <NSObject>

- (void)accountsViewController:(FTAccountsViewController *)controller didSelectAccount:(FTAccount *)account;

@end


@interface FTAccountsViewController : FTViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <FTAccountsViewControllerDelegate> delegate;


@end
