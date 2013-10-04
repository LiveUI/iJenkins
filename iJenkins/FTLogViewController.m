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
@property (nonatomic) NSInteger jobNumber;

@property (nonatomic, strong) AFHTTPRequestOperation *download;
@property (nonatomic, strong) NSMutableData *data;

@end


@implementation FTLogViewController


#pragma mark Creating elements

- (void)createTextView {
    _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    [_textView setAutoresizingWidthAndHeight];
    [self.view addSubview:_textView];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTextView];
}

#pragma mark Initialization

- (id)initWithJobName:(NSString *)jobName andJobNumber:(NSInteger)jobNumber {
    self = [super init];
    if (self) {
        [self setTitle:FTLangGet(@"Build log")];
        
        _jobName = jobName;
        _jobNumber = jobNumber;
        
        
    }
    return self;
}


@end
