//
//  FTThemeProtocol.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 01/11/2015.
//  Copyright © 2015 Ridiculous Innovations. All rights reserved.
//

#ifndef FTThemeProtocol_h
#define FTThemeProtocol_h



#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@protocol FTThemeProtocol <NSObject>


// Default values
- (CGFloat)defaultCellHeight;
- (CGFloat)smallTextCellTitleSize;
- (UIColor *)defaultCellTitleColor;
- (UIColor *)defaultCellDetailColor;

// Accounts
- (CGFloat)accountsHeaderCellHeight;
- (CGFloat)accountsNoAccountTextSize;
- (CGFloat)accountsNoAccountIconSize;

// Servers
- (CGFloat)serverCellHeaderHeight;

// Jobs
- (CGFloat)jobCellStatusColorTopSpace;
- (CGFloat)jobCellStatusColorDiameter;
- (CGFloat)jobCellBuildIdFontSize;
- (CGFloat)jobCellXSpace; // Space at the beginning of the cell
- (CGFloat)jobCellEndSpace; // Space at the end of the cell



@end



#endif /* FTThemeProtocol_h */
