//
//  FTNoAccountCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTNoAccountCell.h"
#import "NSString+FontAwesome.h"


@implementation FTNoAccountCell


#pragma mark Creating elements

- (void)createInfoLabel {
    CGFloat size = [[FTTheme sharedTheme] accountsNoAccountTextSize];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, (self.width - 100), (size * 3))];
    [label setTextColor:[UIColor grayColor]];
    [label setText:FTLangGet(@"You don't have any Jenkins instances in the list as yet. Please click here to add a new Jenkins instance")];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setFont:[UIFont systemFontOfSize:size]];
    [label setNumberOfLines:3];
    [label setAutoresizingWidth];
    [self.contentView addSubview:label];
}

- (void)createPlusIcon {
    CGFloat textSize = [[FTTheme sharedTheme] accountsNoAccountTextSize];
    CGFloat size = [[FTTheme sharedTheme] accountsNoAccountIconSize];
    
    FAImageView *plus = [[FAImageView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    [plus.defaultView setBackgroundColor:[UIColor clearColor]];
    [plus.defaultView setTextColor:[UIColor colorWithHexString:@"454545"]];
    [plus setImage:nil];
    [plus setDefaultIconIdentifier:@"icon-plus-sign"];
    [plus setYOrigin:((textSize * 4) + 10)];
    [self.contentView addSubview:plus];
    [plus centerHorizontally];
    [plus setAutoresizingTopCenter];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createInfoLabel];
    [self createPlusIcon];
}


@end
