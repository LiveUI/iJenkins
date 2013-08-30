//
//  FTViewController.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FTViewController : UIViewController

@property (nonatomic, strong) UIPopoverController *popover;

@property (nonatomic, readonly) BOOL isLandscape;

// Positioning
- (CGFloat)screenHeight;
- (CGFloat)screenWidth;
- (BOOL)isTablet;
- (BOOL)isBigPhone;
- (BOOL)isRetina;
- (BOOL)isOS7;

// Creating and configuring view
- (void)setupView;
- (void)createAllElements;

// Alerts
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;


@end
