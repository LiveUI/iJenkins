//
//  FTBuildDetailChangesViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 04/10/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTBuildDetailChangesViewController.h"
#import "FTSmallTextCell.h"


@interface FTBuildDetailChangesViewController ()

@end


@implementation FTBuildDetailChangesViewController


#pragma mark Creating elements

- (void)createAllElements {
    [super createAllElements];
    
    [self createTableView];
}

#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    [self setTitle:FTLangGet(@"Changes")];
}

#pragma mark Table view delegate & data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _changeSet.items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return ((NSNull *)_changeSet.kind == [NSNull null] ? nil : FTLangGet([_changeSet.kind uppercaseString]));
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"changesCell";
    FTSmallTextCell *cell = (FTSmallTextCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FTSmallTextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    NSDictionary *d = _changeSet.items[indexPath.row];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@\n%@: %@", [d objectForKey:@"msg"], FTLangGet(@"Date"), [d objectForKey:@"date"]]];
    return cell;
}


@end
