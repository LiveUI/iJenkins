//
//  LUILanguage.h
//
//  Created by Ondrej Rafaj on 17/04/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LUILanguage : NSObject

@property (nonatomic) BOOL defaultLanguage;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *currentLanguage;

@property (nonatomic, strong) NSString *localizedName;
@property (nonatomic, strong) NSString *code;

- (instancetype)initWithCode:(NSString *)code;

- (void)reloadLocalizedNameForCode:(NSString *)code;


@end
