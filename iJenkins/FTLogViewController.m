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

#pragma mark Getters

- (NSString *)urlString {
    return [NSString stringWithFormat:@"%@job/%@/%d/consoleText", [[FTAccountsManager sharedManager] selectedAccount].baseUrl, [_jobName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], _jobNumber];
}

#pragma mark Initialization

- (id)initWithJobName:(NSString *)jobName andJobNumber:(NSInteger)jobNumber {
    self = [super init];
    if (self) {
        [self setTitle:FTLangGet(@"Build log")];
        
        _jobName = jobName;
        _jobNumber = jobNumber;
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self urlString]]];
        _download = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        _download.outputStream = [NSOutputStream outputStreamToMemory];
        [_download.outputStream setDelegate:self];
        [_download setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"Response: %@", responseObject);
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [super showAlertWithTitle:FTLangGet(@"Error") andMessage:error.localizedDescription];
        }];
        [_download start];
    }
    return self;
}

#pragma mark Stream delegate methods

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch(eventCode) {
        case NSStreamEventHasBytesAvailable: {
            if(!_data) {
                _data = [NSMutableData data];
            }
            uint8_t buf[1024];
            unsigned int len = 0;
            len = [(NSInputStream *)aStream read:buf maxLength:1024];
            if(len) {
                [_data appendBytes:(const void *)buf length:len];
                // bytesRead is an instance variable of type NSNumber.
                //[bytesRead setIntValue:[bytesRead intValue] + len];
                NSString *s = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
                [_textView setText:s];
            }
            else {
                NSLog(@"no buffer!");
            }
            break;
        }
        default:
            break;
    }
}


@end
