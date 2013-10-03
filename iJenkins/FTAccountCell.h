//
//  FTAccountCell.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 02/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTBasicCell.h"

typedef NS_ENUM(NSUInteger, FTAccountCellReachabilityStatus) {
    FTAccountCellReachabilityStatusUnknown,
    FTAccountCellReachabilityStatusLoading,
    FTAccountCellReachabilityStatusReachable,
    FTAccountCellReachabilityStatusUnreachable
};

@interface FTAccountCell : FTBasicCell



@property (nonatomic, assign) FTAccountCellReachabilityStatus    reachabilityStatus;

@end
