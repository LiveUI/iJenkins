//
//  FTIconCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 06/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTIconCell.h"


@interface FTIconCell ()

@end


@implementation FTIconCell


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets edgeInset = self.separatorInset;
    edgeInset.left = 55;
    self.separatorInset = edgeInset;
}

#pragma mark Creating elements

- (void)createImageView {
    _iconView = [[FAImageView alloc] initWithFrame:CGRectMake(12, 15, 24, 24)];
    [_iconView.defaultView setBackgroundColor:[UIColor clearColor]];
    [_iconView.defaultView setTextColor:[UIColor colorWithHexString:@"454545"]];
    [_iconView setImage:nil];
    [_iconView setDefaultIcon:FAGithub];
    [self addSubview:_iconView];
}

- (void)createAllElements {
    [super createAllElements];
    [self createImageView];
}


@end
