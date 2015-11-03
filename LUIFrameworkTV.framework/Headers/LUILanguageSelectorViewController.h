//
//  LUILanguageSelectorViewController.h
//
//  Created by Ondrej Rafaj on 20/04/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

/**
 *  Use:
 *
 *  LUILanguageSelectorViewController *c = [[LUILanguageSelectorViewController alloc] init];
 *  [self presentViewController:c animated:YES completion:nil];
 */

#import <UIKit/UIKit.h>


@class LUILanguageSelectorContentTableViewController;

@interface LUILanguageSelectorViewController : UINavigationController

/**
 *  Table view controller inside this navigation controller
 *
 *  @note Access through this variable will allow some level of customisation
 */
@property (nonatomic, readonly) LUILanguageSelectorContentTableViewController *contentController;

/**
 *  Cell presentation style in language selector
 *
 *  @note Defaults to UITableViewCellStyleSubtitle
 */
@property (nonatomic) UITableViewCellStyle cellPresentationStyle;


@end
