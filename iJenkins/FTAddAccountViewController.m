//
//  FTAddAccountViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAddAccountViewController.h"
#import "FTTextAccountCell.h"
#import "FTSwitchAccountCell.h"


@interface FTAddAccountViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@property (nonatomic) BOOL keyboardIsOn;

@end


@implementation FTAddAccountViewController


#pragma mark Creating elements

- (void)createTableView {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AccountDetailTemplate" ofType:@"plist"];
    _data = [NSArray arrayWithContentsOfFile:path];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setAutoresizingWidthAndHeight];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
}

- (void)createTopButtons {
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:FTLangGet(@"Close") style:UIBarButtonItemStyleDone target:self action:@selector(didCLickCloseNow:)];
    [self.navigationItem setLeftBarButtonItem:close];

    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:FTLangGet(@"Save") style:UIBarButtonItemStyleDone target:self action:@selector(didCLickSaveNow:)];
    [self.navigationItem setRightBarButtonItem:edit];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTableView];
    [self createTopButtons];
}

#pragma mark Actions

- (void)didCLickCloseNow:(UIBarButtonItem *)sender {
    if ([_delegate respondsToSelector:@selector(addAccountViewControllerCloseWithoutSave:)]) {
        [_delegate addAccountViewControllerCloseWithoutSave:self];
    }
}

- (void)didCLickSaveNow:(UIBarButtonItem *)sender {
    if (_isNew) {
        if ([_delegate respondsToSelector:@selector(addAccountViewController:didAddAccount:)]) {
            _isNew = NO;
            [_delegate addAccountViewController:self didAddAccount:_account];
        }
    }
    else {
        if ([_delegate respondsToSelector:@selector(addAccountViewController:didModifyAccount:)]) {
            [_delegate addAccountViewController:self didModifyAccount:_account];
        }
    }
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if (_keyboardIsOn) {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [_tableView setHeight:(self.view.height - 162)];
        }
        else {
            [_tableView setHeight:(self.view.height - 216)];
        }
    }
}

#pragma mark Table view delegate & data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[_data objectAtIndex:section] objectForKey:@"items"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 44 : 24;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return FTLangGet([[_data objectAtIndex:section] objectForKey:@"name"]);
}

- (FTBasicAccountCell *)switchCell {
    static NSString *identifier = @"switchCell";
    FTSwitchAccountCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTSwitchAccountCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

- (FTBasicAccountCell *)textCell {
    static NSString *identifier = @"textCell";
    FTTextAccountCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTTextAccountCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *d = [[[_data objectAtIndex:indexPath.section] objectForKey:@"items"] objectAtIndex:indexPath.row];
    FTBasicAccountCell *cell;
    if ([[d objectForKey:@"type"] isEqualToString:@"switch"]) {
        cell = [self switchCell];
    }
    else {
        cell = [self textCell];
    }
    [cell setDelegate:self];
    [cell setIndexPath:indexPath];
    [cell setCellData:d];
    [cell setAccount:_account];
    return cell;
}

#pragma mark Basic account cell delegate methods

- (void)basicAccountCell:(FTBasicAccountCell *)cell didStartEditing:(BOOL)editing {
    _keyboardIsOn = editing;
    [UIView animateWithDuration:0.3 animations:^{
        if (editing) {
            if (_tableView.height == self.view.height) {
                [_tableView setHeight:(self.view.height - 216)];
            }
        }
        else {
            if (_tableView.height < self.view.height) {
                [_tableView setHeight:(self.view.height)];
            }
        }
        [_tableView scrollToRowAtIndexPath:cell.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }];
}

- (void)basicAccountCellDidChangeValue:(FTBasicAccountCell *)cell {
    
}


@end
