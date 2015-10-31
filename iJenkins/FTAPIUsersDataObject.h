//
//  FTAPIUsersDataObject.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 08/10/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTAPIUserDetailDataObject.h"


@interface FTAPIUsersDataObject : FTAPIDataObject <FTAPIDataAbstractObject>

@property (nonatomic, strong) NSArray *users;


@end


@interface FTAPIUsersInfoDataObject : NSObject

@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, readonly) NSString *nickName;
@property (nonatomic, readonly) NSString *absoluteUrl;
@property (nonatomic, readonly) NSTimeInterval lastChange;
@property (nonatomic, readonly) FTAPIJobDataObject *project;

- (void)processData:(NSDictionary *)data;


@end