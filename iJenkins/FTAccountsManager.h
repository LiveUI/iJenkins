//
//  FTAccountsManager.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAccount.h"


#define kAccountsManager                        [FTAccountsManager sharedManager];


@interface FTAccountsManager : NSObject


+ (id)sharedManager;

- (void)addAccount:(FTAccount *)account;
- (void)removeAccount:(FTAccount *)account;
- (void)moveAccount:(FTAccount *)account toIndex:(NSInteger)newIndex;
- (NSArray *)accounts;

- (void)createDemoAccount;


@end
