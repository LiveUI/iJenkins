//
//  FTBasicCell.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    FTBasicCellLayoutTypeDefault,
    FTBasicCellLayoutTypeSmall
} FTBasicCellLayoutType;


@interface FTBasicCell : UITableViewCell

@property (nonatomic) FTBasicCellLayoutType layoutType;

+ (FTBasicCell *)cellForTable:(UITableView *)tableView;

- (void)createAllElements;
- (void)setupView;

- (CGFloat)cellHeight;
+ (CGFloat)cellHeight;


@end
