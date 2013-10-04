//
//  FTLogViewController.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 04/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTLogViewController.h"
#import "AFNetworking.h"


@interface FTLogViewController ()

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) NSString *jobName;
@property (nonatomic) NSInteger buildNumber;

@property (nonatomic, strong) AFHTTPRequestOperation *download;
@property (nonatomic, strong) NSMutableData *data;

@property (nonatomic) NSInteger errorCount;

@end


@implementation FTLogViewController


#pragma mark Data

- (void)loadData {
    [self createSpinner];
    FTAPIBuildConsoleOutputDataObject *loadObject = [[FTAPIBuildConsoleOutputDataObject alloc] initWithJobName:_jobName andBuildNumber:_buildNumber];
    [FTAPIConnector connectWithObject:loadObject andOnCompleteBlock:^(id<FTAPIDataAbstractObject> dataObject, NSError *error) {
        if (error) {
            if (_errorCount <= 3) {
                _errorCount++;
                [self loadData];
            }
            else {
                
            }
        }
        else {
            [self createReloadButton];
            [_textView setText:loadObject.outputText];
            // TODO: Find better way to load data
            if ([loadObject.response.allHeaderFields objectForKey:@"X-More-Data"]) {
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(loadData) userInfo:nil repeats:NO];
            }
            else {
                
            }
        }
    }];
}

#pragma mark Creating elements

- (void)createTextView {
    _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    [_textView setAutoresizingWidthAndHeight];
    [self.view addSubview:_textView];
}

- (void)createSpinner {
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [ai startAnimating];
    UIBarButtonItem *spin = [[UIBarButtonItem alloc] initWithCustomView:ai];
    [self.navigationItem setRightBarButtonItem:spin animated:YES];
}

- (void)createReloadButton {
    UIBarButtonItem *reload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadData)];
    [self.navigationItem setRightBarButtonItem:reload animated:YES];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTextView];
}

#pragma mark Initialization

- (id)initWithJobName:(NSString *)jobName andBuildNumber:(NSInteger)buildNumber {
    self = [super init];
    if (self) {
        [self setTitle:FTLangGet(@"Build log")];
        
        _jobName = jobName;
        _buildNumber = buildNumber;
        _errorCount = 0;
        
        [self loadData];
    }
    return self;
}


@end
