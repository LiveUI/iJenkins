//
//  FTThemetvOS.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 01/11/2015.
//  Copyright © 2015 Ridiculous Innovations. All rights reserved.
//

#import "FTThemetvOS.h"


@implementation FTThemetvOS


#pragma mark - General values
#pragma mark Cells

- (CGFloat)defaultCellHeight {
    return 100;
}

- (CGFloat)smallTextCellTitleSize {
    return 34;
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
    return 300;
}

- (CGFloat)accountsNoAccountTextSize {
    return 34;
}

- (CGFloat)accountsNoAccountIconSize {
    return 40;
}

#pragma mark - Servers
#pragma mark Cells

- (CGFloat)serverCellHeaderHeight {
    return 218;
}

#pragma mark - Jobs
#pragma mark Cells

- (CGFloat)jobCellStatusColorTopSpace {
    return 16;
}

- (CGFloat)jobCellStatusColorDiameter {
    return 30;
}

- (CGFloat)jobCellBuildIdFontSize {
    return 24;
}

- (CGFloat)jobCellXSpace {
    return 40;
}

- (CGFloat)jobCellEndSpace {
    return 70;
}


@end
