//
//  FTManageNodesViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 07/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTManageNodesViewController.h"
#import "FTNodeCell.h"


@interface FTManageNodesViewController ()

@property (nonatomic, strong) NSArray *data;

@end


@implementation FTManageNodesViewController


#pragma Data

- (void)loadData {
    FTAPIComputerObject *buildsObject = [[FTAPIComputerObject alloc] init];
    [FTAPIConnector connectWithObject:buildsObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
        _data = buildsObject.computers;
        [self.tableView reloadData];
    }];
}

#pragma mark Initialization

- (void)setupView {
    [super setupView];
}

#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
    
    [self createTableView];
    
    [self loadData];
}

#pragma mark Table view delegate & datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (_data.count == 0) ? 1 : _data.count;
}



@end
