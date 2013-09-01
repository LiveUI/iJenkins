//
//  FTBasicAccountCell.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 31/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTBasicCell.h"


@class FTBasicAccountCell;

@protocol FTBasicAccountCellDelegate <NSObject>

- (void)basicAccountCellDidChangeValue:(FTBasicAccountCell *)cell;
- (void)basicAccountCell:(FTBasicAccountCell *)cell didStartEditing:(BOOL)editing;

@end


@interface FTBasicAccountCell : FTBasicCell

@property (nonatomic, strong) NSDictionary *cellData;
@property (nonatomic, strong) FTAccount *account;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id <FTBasicAccountCellDelegate> delegate;

- (void)cellDidChangeValue;


@end
