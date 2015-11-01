//
//  FTThemeiOS.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 01/11/2015.
//  Copyright © 2015 Ridiculous Innovations. All rights reserved.
//

#import "FTThemeiOS.h"


@implementation FTThemeiOS


#pragma mark - General values
#pragma mark Cells

- (CGFloat)defaultCellHeight {
    return 54;
}

- (CGFloat)smallTextCellTitleSize {
    return 12;
}

- (UIColor *)defaultCellTitleColor {
    return [UIColor colorWithHexString:@"454545"];
}

- (UIColor *)defaultCellDetailColor {
    return [UIColor colorWithHexString:@"6C6C6C"];
}


#pragma mark - Accounts
#pragma mark Cells

- (CGFloat)accountsHeaderCellHeight {
    return 100;
}

- (CGFloat)accountsNoAccountTextSize {
    return 12;
}

- (CGFloat)accountsNoAccountIconSize {
    return 20;
}

#pragma mark - Servers
#pragma mark Cells

- (CGFloat)serverCellHeaderHeight {
    return 218;
}

#pragma mark - Jobs
#pragma mark Cells

- (CGFloat)jobCellStatusColorTopSpace {
    return 10;
}

- (CGFloat)jobCellStatusColorDiameter {
    return 14;
}

- (CGFloat)jobCellBuildIdFontSize {
    return 10;
}

- (CGFloat)jobCellXSpace {
    return 8;
}

- (CGFloat)jobCellEndSpace {
    return 55;
}


@end
