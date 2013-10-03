//
//  FTAccountCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 02/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAccountCell.h"


@interface FTAccountCell ()

@property (nonatomic, strong) UIView *accessIndicator;

@end


@implementation FTAccountCell


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel setXOrigin:36];
    [self.detailTextLabel setXOrigin:36];
}

#pragma mark Creating elements

- (void)createAccessIndicator {
    _accessIndicator = [[UIView alloc] initWithFrame:CGRectMake(14, 23, 8, 8)];
    [_accessIndicator setBackgroundColor:[UIColor lightGrayColor]];
    [_accessIndicator.layer setCornerRadius:(_accessIndicator.width / 2)];
    _accessIndicator.layer.shouldRasterize = YES;
    _accessIndicator.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    [self addSubview:_accessIndicator];
}

- (void)createAllElements {
    [super createAllElements];
    [self createAccessIndicator];
    
    [self setReachabilityStatus:FTAccountCellReachabilityStatusUnknown];
}

#pragma mark Accessors

- (void)setReachabilityStatus:(FTAccountCellReachabilityStatus)reachabilityStatus {
    _reachabilityStatus = reachabilityStatus;
    UIColor *statusIndicatorColor = [UIColor lightGrayColor];
    switch (_reachabilityStatus) {
        case FTAccountCellReachabilityStatusLoading:
            break;
        case FTAccountCellReachabilityStatusUnreachable:
            statusIndicatorColor = [UIColor colorWithHexString:@"FF4000"];
            break;
        case FTAccountCellReachabilityStatusReachable:
            statusIndicatorColor = [UIColor colorWithHexString:@"6DD900"];
            break;
        default:
            break;
    }
    [_accessIndicator setBackgroundColor:statusIndicatorColor];
}


@end
