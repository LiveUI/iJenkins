//
//  FTUserDetailViewController.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTViewController.h"
#import <MessageUI/MFMailComposeViewController.h>


@class FTUserDetailViewController;

@protocol FTUserDetailViewControllerDelegate <NSObject>

- (void)userDetailViewController:(FTUserDetailViewController *)controller didDeleteUser:(FTAPIUserDetailDataObject *)user;

@end


@interface FTUserDetailViewController : FTViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSString *nickName;

@property (nonatomic, weak) id <FTUserDetailViewControllerDelegate> delegate;


@end
