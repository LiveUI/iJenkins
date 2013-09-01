//
//  FTJobDetailViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTJobDetailViewController.h"


@interface FTJobDetailViewController ()

@end


@implementation FTJobDetailViewController


#pragma mark Creating elements

- (void)createTopButtons {
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:FTLangGet(@"Build Now") style:UIBarButtonItemStylePlain target:self action:@selector(didCLickRunBuildNow:)];
    [self.navigationItem setRightBarButtonItem:edit];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTopButtons];
}

#pragma mark Actions

- (void)didCLickRunBuildNow:(UIBarButtonItem *)sender {
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [ai startAnimating];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithCustomView:ai];
    [self.navigationItem setRightBarButtonItem:edit];
    
    NSString *url = [NSString stringWithFormat:@"%@job/%@/build", [kAccountsManager selectedAccount].baseUrl, [_job.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:8.0];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createTopButtons];
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode >= 400) {
                NSString *message = [NSString stringWithFormat:@"%@ (%@: %d)", FTLangGet(@"We were unable to reach the server, please try again later."), FTLangGet(@"HTTP Error"), statusCode];
                [super showAlertWithTitle:FTLangGet(@"Request error") andMessage:message];
            }
        });
    }];
}


@end
