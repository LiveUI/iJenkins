//
//  FTNoJobCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 14/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTNoJobCell.h"
#import "NSString+FontAwesome.h"


@implementation FTNoJobCell


#pragma mark Creating elements

- (void)createInfoLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, (self.width - 100), 45)];
    [label setTextColor:[UIColor grayColor]];
    [label setText:FTLangGet(@"There are no jobs available in this view. Please click here to select another view.")];
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
    [plus setDefaultIconIdentifier:@"icon-reorder"];
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
