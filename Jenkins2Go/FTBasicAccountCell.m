//
//  FTBasicAccountCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 31/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTBasicAccountCell.h"


@implementation FTBasicAccountCell


#pragma mark Settings

- (void)setCellData:(NSDictionary *)cellData {
    _cellData = cellData;
    [self.textLabel setText:FTLangGet([cellData objectForKey:@"name"])];
    if ([[cellData objectForKey:@"name"] length] > 0) {
        [self.detailTextLabel setText:FTLangGet([cellData objectForKey:@"description"])];
    }
}

#pragma mark Delegate helper

- (void)cellDidChangeValue {
    if ([_delegate respondsToSelector:@selector(basicAccountCellDidChangeValue:)]) {
        [_delegate basicAccountCellDidChangeValue:self];
    }
}


@end
