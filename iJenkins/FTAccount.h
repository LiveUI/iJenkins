//
//  FTAccount.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTAccount : NSObject

@property (nonatomic, strong) NSMutableDictionary *originalDictionary;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *pathSuffix;
@property (nonatomic) BOOL https;
@property (nonatomic) NSInteger port;
@property (nonatomic) BOOL xpath;
@property (nonatomic) NSTimeInterval timeout;
@property (nonatomic) BOOL overrideJenkinsUrl;
@property (nonatomic) NSInteger loadMaxItems;
@property (nonatomic) double buildLogMaxSize;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *passwordOrToken;

- (NSString *)baseUrl;


@end
