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

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableDictionary *originalDictionary;

@property (nonatomic) BOOL keyboardIsOn;

@end


@implementation FTAddAccountViewController


#pragma mark Creating elements

- (void)createTableView {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AccountDetailTemplate" ofType:@"plist"];
    _data = [NSArray arrayWithContentsOfFile:path];
    super.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [super.tableView setAutoresizingWidthAndHeight];
    [super.tableView setDataSource:self];
    [super.tableView setDelegate:self];
    [self.view addSubview:super.tableView];
}

- (void)createTopButtons {
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:FTLangGet(@"Close") style:UIBarButtonItemStylePlain target:self action:@selector(didCLickCloseNow:)];
    [self.navigationItem setLeftBarButtonItem:close];

    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:FTLangGet(@"Save") style:UIBarButtonItemStyleDone target:self action:@selector(didCLickSaveNow:)];
    [self.navigationItem setRightBarButtonItem:edit];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTableView];
    [self createTopButtons];
}

#pragma mark Resetting Method

- (void)resetAccountToOriginalStateIfNotNew {
    if (!_isNew)[_account setOverridingDictionary:self.originalDictionary];
}

#pragma mark Settings

- (void)setAccount:(FTAccount *)account {
    _account = account;
    // Retain dictionary in FTAccount to allow revert
    self.originalDictionary = [account.originalDictionary copy];
}

#pragma mark Actions

- (void)didCLickCloseNow:(UIBarButtonItem *)sender {
    if ([_delegate respondsToSelector:@selector(addAccountViewControllerCloseWithoutSave:)]) {
        [_delegate addAccountViewControllerCloseWithoutSave:self];
    }
}

- (void)didCLickSaveNow:(UIBarButtonItem *)sender {
    [self.view.window endEditing:YES];
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
    
    [super.tableView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if (_keyboardIsOn) {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            [super.tableView setHeight:(self.view.height - 162)];
        }
        else {
            [super.tableView setHeight:(self.view.height - 216)];
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
    FTSwitchAccountCell *cell = [super.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTSwitchAccountCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

- (FTBasicAccountCell *)textCell {
    static NSString *identifier = @"textCell";
    FTTextAccountCell *cell = [super.tableView dequeueReusableCellWithIdentifier:identifier];
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
    if ([[d objectForKey:@"type"] isEqualToString:@"url"] || [[d objectForKey:@"type"] isEqualToString:@"username"]) {
        [[(FTTextAccountCell *)cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [[(FTTextAccountCell *)cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
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
            if (super.tableView.height == self.view.height) {
                [super.tableView setHeight:(self.view.height - 216)];
            }
        }
        else {
            if (super.tableView.height < self.view.height) {
                [super.tableView setHeight:(self.view.height)];
            }
        }
        [super.tableView scrollToRowAtIndexPath:cell.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }];
}

- (void)basicAccountCellDidChangeValue:(FTBasicAccountCell *)cell {
    NSDictionary *data = cell.cellData;
    if ([[data objectForKey:@"type"] isEqualToString:@"switch"] && [[data objectForKey:@"variable"] isEqualToString:@"https"] && self.account.https) {
        self.account.port = 443;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    
}

- (void)basicAccountCellTextfieldDidResign:(FTBasicAccountCell *)cell {
    [self basicAccountCell:cell didStartEditing:NO];
}


@end
