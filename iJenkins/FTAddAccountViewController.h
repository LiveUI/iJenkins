//
//  FTAddAccountViewController.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTViewController.h"
#import "FTBasicAccountCell.h"


@class FTAccount, FTAddAccountViewController;

@protocol FTAddAccountViewControllerDelegate <NSObject>

- (void)addAccountViewController:(FTAddAccountViewController *)controller didModifyAccount:(FTAccount *)account;
- (void)addAccountViewController:(FTAddAccountViewController *)controller didAddAccount:(FTAccount *)account;

@end


@interface FTAddAccountViewController : FTViewController <UITableViewDataSource, UITableViewDelegate, FTBasicAccountCellDelegate>

@property (nonatomic, strong) FTAccount *account;
@property (nonatomic, weak) id <FTAddAccountViewControllerDelegate> delegate;


@end
