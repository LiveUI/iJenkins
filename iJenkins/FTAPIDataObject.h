//
//  FTAPIDataObject.h
//  Cronycle
//
//  Created by Ondrej Rafaj on 13/08/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, FTAPIDataObjectOutputType) {
    FTAPIDataObjectOutputTypeJSON,
    FTAPIDataObjectOutputTypePlainText
};


@protocol FTAPIDataAbstractObject <NSObject>

@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic) FTAPIDataObjectOutputType outputType;

- (FTHttpMethod)httpMethod;
- (NSString *)methodName;
- (NSDictionary *)payloadData;
- (void)processData:(NSDictionary *)data;
- (void)processText:(NSString *)text;
- (void)processHeaders:(NSDictionary *)headers;

- (void)resetLoading;
- (NSOperationQueuePriority)queuePriority;
- (NSString *)suffix;
- (NSInteger)depth;


@end


@interface FTAPIDataObject : NSObject

@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic) FTAPIDataObjectOutputType outputType;

@property (nonatomic, strong) NSError *connectionError;
@property (nonatomic, strong, readonly) NSArray *apiErrors;
@property (nonatomic, readonly) BOOL success;

@property (nonatomic) BOOL printOutputToConsole;

@property (nonatomic) NSInteger responseStatusCode;

- (void)processData:(NSDictionary *)data;
- (void)processText:(NSString *)text;
- (void)processHeaders:(NSDictionary *)headers;

- (void)resetLoading;

- (NSOperationQueuePriority)queuePriority;

- (NSString *)suffix;
- (NSInteger)depth;


@end
