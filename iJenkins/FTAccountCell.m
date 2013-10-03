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
@property (nonatomic, strong) UIActivityIndicatorView   *activityIndicator;

@end


@implementation FTAccountCell


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel setXOrigin:36];
    [self.detailTextLabel setXOrigin:36];
    
    _activityIndicator.center = _accessIndicator.center;
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
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.hidesWhenStopped = YES;
    [self addSubview:_activityIndicator];
    
    [self setReachabilityStatus:FTAccountCellReachabilityStatusUnknown];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Accessors

- (void)setReachabilityStatus:(FTAccountCellReachabilityStatus)reachabilityStatus
{
    _reachabilityStatus = reachabilityStatus;
    
    BOOL activityIndicatorRunning = NO;
    BOOL statusIndicatorHidden = NO;
    UIColor *statusIndicatorColor = [UIColor lightGrayColor];
    
    switch (_reachabilityStatus) {
        case FTAccountCellReachabilityStatusLoading:
            statusIndicatorHidden = YES;
            activityIndicatorRunning = YES;
            break;
        case FTAccountCellReachabilityStatusUnreachable:
            activityIndicatorRunning = NO;
            statusIndicatorColor = [UIColor colorWithHexString:@"FF4000"];
            break;
        case FTAccountCellReachabilityStatusReachable:
            activityIndicatorRunning = NO;
            statusIndicatorColor = [UIColor colorWithHexString:@"6DD900"];
            break;
        default:
            break;
    }
    
    //  Configure view
    if (activityIndicatorRunning) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
    
    _accessIndicator.hidden = statusIndicatorHidden;
    _accessIndicator.backgroundColor = statusIndicatorColor;
}


@end
