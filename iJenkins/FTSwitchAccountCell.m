//
//  FTSwitchAccountCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 31/08/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTSwitchAccountCell.h"


@interface FTSwitchAccountCell ()

@property (nonatomic, strong) id cellSwitch;

@end


@implementation FTSwitchAccountCell


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark Create elements

- (void)createSwitch {
#if TARGET_OS_IOS || (TARGET_OS_IPHONE && !TARGET_OS_TV)
    _cellSwitch = [[UISwitch alloc] init];
    [_cellSwitch addTarget:self action:@selector(switchDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    [_cellSwitch setOrigin:CGPointMake((self.width - 14 - [(UISwitch *)_cellSwitch width]), 6)];
    [_cellSwitch setAutoresizingCenterRight];
    [self.contentView addSubview:_cellSwitch];
#endif
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createSwitch];
}

#pragma mark Settings

- (void)setCellData:(NSDictionary *)cellData {
    [super setCellData:cellData];
}

- (void)setAccount:(FTAccount *)account {
    [super setAccount:account];
    
    NSString *variable = [self.cellData objectForKey:@"variable"];
    if ([variable isEqualToString:@"https"]) {
        [_cellSwitch setOn:account.https];
    }
    else if ([variable isEqualToString:@"overrideJenkinsUrl"]) {
        [_cellSwitch setOn:account.overrideJenkinsUrl];
    }
    else if ([variable isEqualToString:@"xpath"]) {
        [_cellSwitch setOn:account.xpath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark Actions

#if TARGET_OS_IOS || (TARGET_OS_IPHONE && !TARGET_OS_TV)
- (void)switchDidChangeValue:(UISwitch *)sender {
    NSString *variable = [self.cellData objectForKey:@"variable"];
    if ([variable isEqualToString:@"https"]) {
        [self.account setHttps:sender.isOn];
    }
    else if ([variable isEqualToString:@"overrideJenkinsUrl"]) {
        [self.account setOverrideJenkinsUrl:sender.isOn];
    }
    else if ([variable isEqualToString:@"xpath"]) {
        [self.account setXpath:sender.isOn];
    }
    [super cellDidChangeValue];
}
#endif


@end
