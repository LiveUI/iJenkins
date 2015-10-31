//
//  FTAccountCell.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 02/09/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTBasicCell.h"


typedef NS_ENUM(NSUInteger, FTAccountCellReachabilityStatus) {
    FTAccountCellReachabilityStatusUnknown,
    FTAccountCellReachabilityStatusLoading,
    FTAccountCellReachabilityStatusReachable,
    FTAccountCellReachabilityStatusUnreachable
};

@protocol FTAccountCellDelegate;


@interface FTAccountCell : FTBasicCell

@property (nonatomic, weak) id<FTAccountCellDelegate> delegate;
@property (nonatomic, assign) FTAccountCellReachabilityStatus reachabilityStatus;

- (void)copyURL:(id)sender;
- (void)openInBrowser:(id)sender;

@end


/**
 *  Delegate protocol for UIMenuController popup menu actions
 */
@protocol FTAccountCellDelegate <NSObject>

@optional
- (void)accountCellMenuCopyURLSelected:(FTAccountCell *)cell;
- (void)accountCellMenuOpenInBrowserSelected:(FTAccountCell *)cell;

@end