//
//  FTViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTViewController.h"


@interface FTViewController ()

@end


@implementation FTViewController


#pragma mark Positioning

- (BOOL)isTablet {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

- (BOOL)isBigPhone {
    return ([[UIScreen mainScreen] bounds].size.height == 568);
}

- (CGFloat)screenHeight {
    CGFloat h = 0;
    if ([self isTablet]) {
        h = self.isLandscape ? 748 : 1004;
    }
    else {
        h = self.isLandscape ? 300 : ([self isBigPhone] ? 548 : 460);
    }
    return h;
}

- (CGFloat)screenWidth {
    CGFloat w = 0;
    if ([self isTablet]) {
        w = self.isLandscape ? 1024 : 768;
    }
    else {
        w = self.isLandscape ? ([self isBigPhone] ? 568 : 480) : 320;
    }
    return w;
}

- (void)layoutElements {
    if (_popover) {
        [_popover dismissPopoverAnimated:YES];
    }
}

- (BOOL)isRetina {
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0));
}

#pragma mark Creating elements

- (void)createAllElements {
    
}

#pragma mark Initialization

- (void)setupView {
    
}

- (id)init {
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isLandscape = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isLandscape = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
    [self createAllElements];
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([self isTablet]) {
        return UIInterfaceOrientationMaskAll;
    }
    else {
        return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
    }
}

- (void)viewWillLayoutSubviews {
    _isLandscape = UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
    [self layoutElements];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    _isLandscape = UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    return YES;
}

#pragma mark Effects

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:FTLangGet(@"Ok") otherButtonTitles:nil];
    [alert show];
}


@end
