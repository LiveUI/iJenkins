//
//  FTView.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTView.h"

@implementation FTView


#pragma mark Environment

- (BOOL)isRetina {
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0));
}

- (BOOL)isBigPhone {
    return ([[UIScreen mainScreen] bounds].size.height == 568);
}

- (CGFloat)screenHeight {
    return ([self isBigPhone] ? 548 : 460);
}

- (BOOL)isOS7 {
    static BOOL shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending);
    });
    return shared;
}

#pragma mark Creating elements

- (void)createAllElements {
    
}

#pragma mark Initialization

- (void)setupView {
    
}

- (id)init {
    self = [super init];
    if (self) {
        [self setupView];
        [self createAllElements];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
        [self createAllElements];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self createAllElements];
    }
    return self;
}


@end
