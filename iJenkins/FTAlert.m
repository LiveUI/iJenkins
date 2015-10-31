//
//  FTAlert.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 31/10/2015.
//  Copyright © 2015 Ridiculous Innovations. All rights reserved.
//

#import "FTAlert.h"


@implementation FTAlert


+ (void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message andCancelButton:(NSString *)cancelButton {
#if TARGET_OS_IOS || (TARGET_OS_IPHONE && !TARGET_OS_TV)
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButton otherButtonTitles:nil];
    [alert show];
#elif TARGET_OS_TV

#warning Finish errors for tvOS

#endif
}


@end
