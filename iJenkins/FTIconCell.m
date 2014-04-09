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
    
    [self.textLabel setXOrigin:55];
    [self.detailTextLabel setXOrigin:55];
    
    [self.textLabel setWidth:MIN(self.textLabel.width, (self.contentView.width - self.textLabel.xOrigin))];
    [self.detailTextLabel setWidth:MIN(self.detailTextLabel.width, (self.contentView.width - self.detailTextLabel.xOrigin))];
}

#pragma mark Creating elements

- (void)createImageView {
    _iconView = [[FAImageView alloc] initWithFrame:CGRectMake(12, 15, 24, 24)];
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
