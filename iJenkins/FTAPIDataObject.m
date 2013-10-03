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

/**
 *  Data for request
 *
 *  @return Return a dictionary of values for POST or GET
 */
- (NSDictionary *)payloadData {
    [NSException raise:@"Payload value method has to be subclassed" format:@"-payloadData method is invalid"];
    return nil;
}

#pragma mark Handling connections

/**
 *  Reset loading
 */
- (void)resetLoading {
    NSLog(@"Resetting loading for %@", NSStringFromClass(self.class));
}

/**
 *  Set priority for this operation
 *
 *  @return Queue priority
 */
- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

#pragma mark Processing data

/**
 *  Process data coming from the JSON API
 *
 *  @param data API data
 */
- (void)processData:(NSDictionary *)data {
    
}

/**
 *  Process headers coming from the API
 *
 *  @param headers Request headers
 */
- (void)processHeaders:(NSDictionary *)headers {
    
}

/**
 *  Suffix for the URL request, by default this is api/json, it is empty only for some link based actions
 *
 *  @return URL suffix after method name
 */
- (NSString *)suffix {
    return @"api/json";
}


@end
