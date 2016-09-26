//
//  FTLoginAlert.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 10/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTHTTPCodes.h"


#define dFTLoginAlert           [FTLoginAlert sharedInstance]


typedef void (^FTLoginAlertLoginBlock) (NSString *username, NSString *password);
typedef void (^FTLoginAlertCancelBlock) (void);


@interface FTLoginAlert : NSObject <UIAlertViewDelegate>

+ (FTLoginAlert *)sharedInstance;

- (void)showLoginDialogWithLoginBlock:(FTLoginAlertLoginBlock)loginBlock andCancelBlock:(FTLoginAlertCancelBlock)cancelBlock;
- (void)showLoginDialogWithLoginBlock:(FTLoginAlertLoginBlock)loginBlock andCancelBlock:(FTLoginAlertCancelBlock)cancelBlock accordingToResponseCode:(HTTPCode)responseCode;


@end
