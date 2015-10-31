//
//  FTAlert.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 31/10/2015.
//  Copyright © 2015 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTAlert : NSObject

+ (void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message andCancelButton:(NSString *)cancelButton;


@end
