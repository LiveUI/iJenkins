//
//  FTImageCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 06/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTImageCell.h"


@interface FTImageCell ()

@end


@implementation FTImageCell


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel setXOrigin:66];
    [self.detailTextLabel setXOrigin:66];
}

#pragma mark Creating elements

- (void)createImageView {
    _iconView = [[FAImageView alloc] initWithFrame:CGRectMake(10, 5, 44, 44)];
    [_iconView.defaultView setBackgroundColor:[UIColor clearColor]];
    [_iconView.defaultView setTextColor:[UIColor colorWithHexString:@"454545"]];
    [_iconView setImage:nil];
    [_iconView setDefaultIconIdentifier:@"icon-github"];
    [self addSubview:_iconView];
}

- (void)createAllElements {
    [super createAllElements];
    [self createImageView];
}


@end
