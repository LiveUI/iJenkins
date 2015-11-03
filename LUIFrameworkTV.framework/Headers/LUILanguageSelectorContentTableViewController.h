//
//  LUILanguageSelectorContentTableViewController.h
//
//  Created by Ondrej Rafaj on 31/05/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

/**
 *  Use:
 *
 *  LUILanguageSelectorContentTableViewController *c = [[LUILanguageSelectorContentTableViewController alloc] init];
 *  [self.navigationController pushViewController:c animated:YES];
 */

#import <UIKit/UIKit.h>


@interface LUILanguageSelectorContentTableViewController : UITableViewController

/**
 *  Cell presentation style in language selector
 *
 *  @note Defaults to UITableViewCellStyleSubtitle
 */
@property (nonatomic) UITableViewCellStyle cellPresentationStyle;

/**
 *  Reload language data
 *
 *  @note If update to the localisations has happened while this controller is visible, the data will be reloaded automatically
 */
- (void)reloadData;

/**
 *  Close or pop back to the app
 */
- (void)close;


@end
