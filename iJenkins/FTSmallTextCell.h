//
//  FTSmallTextCell.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 12/09/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTBasicCell.h"


@interface FTSmallTextCell : FTBasicCell

@property (nonatomic, strong) NSString *text;

+ (FTSmallTextCell *)smallTextCellForTable:(UITableView *)tableView withText:(NSString *)text;


@end
