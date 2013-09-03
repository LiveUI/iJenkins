//
//  FTHomeViewController.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAccountsViewController.h"
#import "FTAccountOverviewCell.h"

@interface FTHomeViewController : FTViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FTAccountOverviewCellDelegate>

@end
