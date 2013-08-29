//
//  FTAPIDataObject.m
//  Cronycle
//
//  Created by Ondrej Rafaj on 13/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIDataObject.h"


@implementation FTAPIDataObject


#pragma mark Generating request

- (NSDictionary *)payloadData {
    [NSException raise:@"Payload value method has to be subclassed" format:@"-payloadData method is invalid"];
    return nil;
}

#pragma mark Processing data

- (void)processData:(NSDictionary *)data {
    
}

- (void)processHeaders:(NSDictionary *)headers {
    
}


@end
