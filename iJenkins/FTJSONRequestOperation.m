//
//  FTJSONRequestOperation.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 13/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTJSONRequestOperation.h"


@implementation FTJSONRequestOperation


#pragma mark Operations handling

- (void)cancel {
    //[super cancel];
    
    [_dataObject resetLoading];
}

- (void)finalize {
    [super finalize];
}


@end
