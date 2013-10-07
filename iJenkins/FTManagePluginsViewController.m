//
//  FTManagePluginsViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 07/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTManagePluginsViewController.h"


@interface FTManagePluginsViewController ()

@property (nonatomic, strong) NSArray *data;

@end


@implementation FTManagePluginsViewController


#pragma mark Initialization

- (void)setupView {
    [super setupView];
}

#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
    [super createTableView];
}


@end
