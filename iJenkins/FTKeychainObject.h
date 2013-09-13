//
//  FTKeychainObject.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 13/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTKeychainObject : NSObject

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *accountsJsonFile;

+ (FTKeychainObject *)sharedKeychainObject;

- (void)logout;


@end
