//
//  FTAddAccountViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAddAccountViewController.h"
#import "FTAccountsManager.h"


@interface FTAddAccountViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end


@implementation FTAddAccountViewController


#pragma mark Creating elements

- (void)createTableView {
//    _data = [kAccountsManager accounts];
//    _demoAccount = [kAccountsManager demoAccount];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setAutoresizingWidthAndHeight];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
}

- (void)createTopButtons {
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:FTLangGet(@"Save") style:UIBarButtonItemStyleDone target:self action:@selector(didCLickSaveNow:)];
    [self.navigationItem setRightBarButtonItem:edit];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTableView];
    [self createTopButtons];
}

#pragma mark Actions

- (void)didCLickSaveNow:(UIBarButtonItem *)sender {
    FTAccount *acc = [kAccountsManager demoAccount];
    [kAccountsManager addAccount:acc];
    
    if ([_delegate respondsToSelector:@selector(addAccountViewController:didModifyAccount:)]) {
        [_delegate addAccountViewController:self didModifyAccount:acc];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Table view delegate & data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


@end
