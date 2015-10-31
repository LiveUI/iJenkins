//
//  FTAPIUserDetailDataObject.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 08/10/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTAPIDataObject.h"


typedef NS_ENUM(NSInteger, FTAPIUserDetailDataObjectAction) {
    FTAPIUserDetailDataObjectActionFetch,
    FTAPIUserDetailDataObjectActionDelete
};


@interface FTAPIUserDetailDataObject : FTAPIDataObject <FTAPIDataAbstractObject>

@property (nonatomic) FTAPIUserDetailDataObjectAction action;

@property (nonatomic, readonly) NSString *nickName;

@property (nonatomic, readonly) NSString *absoluteUrl;
@property (nonatomic, readonly) NSString *userDescription;
@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, readonly) NSArray *property;
@property (nonatomic, readonly) BOOL insensitiveSearch;
@property (nonatomic, readonly) NSString *emailAddress;

- (id)initWithNickName:(NSString *)nickName;


@end
