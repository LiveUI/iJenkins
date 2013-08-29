//
//  FTAccountsManager.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAccount.h"


#define kAccountsManager                        [FTAccountsManager sharedManager]


@interface FTAccountsManager : NSObject

@property (nonatomic, strong) FTAccount *selectedAccount;


+ (FTAccountsManager *)sharedManager;

- (void)addAccount:(FTAccount *)account;
- (void)removeAccount:(FTAccount *)account;
- (void)moveAccount:(FTAccount *)account toIndex:(NSInteger)newIndex;
- (NSArray *)accounts;

- (FTAccount *)demoAccount;


@end
