//
//  FTBasicCell.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    FTBasicCellLayoutTypeSmall,
    FTBasicCellLayoutTypeDefault
} FTBasicCellLayoutType;


@interface FTBasicCell : UITableViewCell

@property (nonatomic) FTBasicCellLayoutType layoutType;

- (void)createAllElements;
- (void)setupView;


@end
