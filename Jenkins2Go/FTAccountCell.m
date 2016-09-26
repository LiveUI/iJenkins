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
    
    UIEdgeInsets edgeInset = self.separatorInset;
    edgeInset.left = 36;
    self.separatorInset = edgeInset;
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

#pragma mark - UIMenuController

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copyURL:) || action == @selector(openInBrowser:));
}

#pragma mark Menu controller actions

- (void)copyURL:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(accountCellMenuCopyURLSelected:)]) {
        [self.delegate accountCellMenuCopyURLSelected:self];
    }
}

- (void)openInBrowser:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(accountCellMenuOpenInBrowserSelected:)]) {
        [self.delegate accountCellMenuOpenInBrowserSelected:self];
    }
}

@end
