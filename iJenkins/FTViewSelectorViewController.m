//
//  FTViewSelectorViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 14/09/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTViewSelectorViewController.h"


@interface FTViewSelectorViewController ()

@end


@implementation FTViewSelectorViewController


#pragma mark Creating elements

- (void)createCloseButton {
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:FTLangGet(@"Close") style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    [self.navigationItem setRightBarButtonItem:close animated:NO];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self setTitle:FTLangGet(@"View selector")];
    
    [super createTableView];
    [self createCloseButton];
}

#pragma mark Settings

- (void)setViews:(NSArray *)views {
    _views = views;
    [self.tableView reloadData];
}

#pragma mark Actions

- (void)close:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark Table view delegate & data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _views.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    FTAPIServerViewDataObject *v = [_views objectAtIndex:indexPath.row];
    [cell.textLabel setText:v.name];
    [cell.detailTextLabel setText:nil];
    if ([_selectedView.name isEqualToString:v.name]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_delegate respondsToSelector:@selector(viewSelectorController:didSelect:)]) {
        FTAPIServerViewDataObject *v = [_views objectAtIndex:indexPath.row];
        [_delegate viewSelectorController:self didSelect:v];
    }
}


@end
