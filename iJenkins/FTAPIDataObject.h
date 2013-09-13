//
//  FTAPIDataObject.h
//  Cronycle
//
//  Created by Ondrej Rafaj on 13/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FTAPIDataAbstractObject <NSObject>

@property (nonatomic, strong) NSHTTPURLResponse *response;

- (FTHttpMethod)httpMethod;
- (NSString *)methodName;
- (NSDictionary *)payloadData;
- (void)processData:(NSDictionary *)data;

- (void)resetLoading;
- (NSOperationQueuePriority)queuePriority;

@end


@interface FTAPIDataObject : NSObject

@property (nonatomic, strong) NSHTTPURLResponse *response;

@property (nonatomic, strong) NSError *connectionError;
@property (nonatomic, strong, readonly) NSArray *apiErrors;
@property (nonatomic, readonly) BOOL success;

@property (nonatomic) BOOL printOutputToConsole;

@property (nonatomic) NSInteger responseStatusCode;

- (void)processData:(NSDictionary *)data;
- (void)processHeaders:(NSDictionary *)headers;

- (void)resetLoading;

- (NSOperationQueuePriority)queuePriority;


@end
