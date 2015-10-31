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


#if TARGET_OS_IOS || (TARGET_OS_IPHONE && !TARGET_OS_TV)

@interface FTLoginAlert : NSObject <UIAlertViewDelegate>

#elif TARGET_OS_TV

@interface FTLoginAlert : NSObject

#endif


+ (FTLoginAlert *)sharedInstance;

- (void)showLoginDialogWithLoginBlock:(FTLoginAlertLoginBlock)loginBlock andCancelBlock:(FTLoginAlertCancelBlock)cancelBlock;
- (void)showLoginDialogWithLoginBlock:(FTLoginAlertLoginBlock)loginBlock andCancelBlock:(FTLoginAlertCancelBlock)cancelBlock accordingToResponseCode:(HTTPCode)responseCode;


@end
