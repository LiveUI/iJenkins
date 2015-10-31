//
//  FTViewController.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FTViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIPopoverController *popover;

@property (nonatomic, readonly) BOOL isLandscape;

@property (nonatomic, strong) UITableView *tableView;

// Positioning
- (CGFloat)screenHeight;
- (CGFloat)screenWidth;
- (BOOL)isTablet;
- (BOOL)isBigPhone;
- (BOOL)isRetina;
- (BOOL)isOS7;

// Creating and configuring view
- (void)setupView;

- (void)createTableView;
- (void)createAllElements;


@end
