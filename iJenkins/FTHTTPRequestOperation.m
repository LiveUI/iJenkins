
//
//  FTHTTPRequestOperation.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 04/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTHTTPRequestOperation.h"


@implementation FTHTTPRequestOperation


#pragma mark Operations handling

- (void)cancel {
    //[super cancel];
    
    [_dataObject resetLoading];
}

- (void)finalize {
    [super finalize];
}


@end
