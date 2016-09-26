//
//  FTJobFolderViewController.h
//  iJenkins
//
//  Created by Chandler Huff on 4/23/16.
//  Copyright © 2016 Fuerte Innovations. All rights reserved.
//


#import "FTAccountsViewController.h"
#import "FTViewSelectorViewController.h"
#import "FTAccountOverviewCell.h"

@interface FTJobFolderViewController : FTViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;

- (id)initWithJob:(FTAPIJobDataObject *)job;

@end
