//
//  FTServerHomeViewController.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAccountsViewController.h"
#import "FTViewSelectorViewController.h"
#import "FTAccountOverviewCell.h"

@interface FTServerHomeViewController : FTViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIAlertViewDelegate, FTAccountOverviewCellDelegate, FTViewSelectorViewControllerDelegate>

@end
