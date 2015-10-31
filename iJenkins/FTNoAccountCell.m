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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, (self.width - 100), 45)];
    [label setTextColor:[UIColor grayColor]];
    [label setText:FTLangGet(@"You don't have any Jenkins instances in the list as yet. Please click here to add a new Jenkins instance")];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setNumberOfLines:3];
    [label setAutoresizingWidth];
    [self addSubview:label];
}

- (void)createPlusIcon {
    FAImageView *plus = [[FAImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [plus.defaultView setBackgroundColor:[UIColor clearColor]];
    [plus.defaultView setTextColor:[UIColor colorWithHexString:@"454545"]];
    [plus setImage:nil];
    [plus setDefaultIconIdentifier:@"icon-plus-sign"];
    [plus setYOrigin:65];
    [self addSubview:plus];
    [plus centerHorizontally];
    [plus setAutoresizingTopCenter];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createInfoLabel];
    [self createPlusIcon];
}


@end
