//
//  FTAPIConnector.h
//  Cronycle
//
//  Created by Ondrej Rafaj on 12/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTAPIJobsDataObject.h"
#import "FTAPIBuildDetailDataObject.h"


#define kAPIConnector                                       [FTAPIConnector sharedConnector]


typedef void(^FTAPIConnectorCompletionHandler) (id <FTAPIDataAbstractObject> dataObject, NSError *error);

typedef void (^FTAPIConnectorProgressDownloadHandler) (NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);
typedef void (^FTAPIConnectorProgressUploadHandler) (NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);


@class FTAccount;

@interface FTAPIConnector : NSObject

@property (nonatomic, strong) NSOperationQueue *apiOperatioQueue;

+ (FTAPIConnector *)sharedConnector;
+ (void)resetForAccount:(FTAccount *)account;
+ (void)stopLoadingAll;

+ (void)connectWithObject:(id<FTAPIDataAbstractObject>)object withOnCompleteBlock:(FTAPIConnectorCompletionHandler)complete withUploadProgressBlock:(FTAPIConnectorProgressUploadHandler)upload andDownloadProgressBlock:(FTAPIConnectorProgressDownloadHandler)download;

+ (void)connectWithObject:(id<FTAPIDataAbstractObject>)object withOnCompleteBlock:(FTAPIConnectorCompletionHandler)complete andDownloadProgressBlock:(FTAPIConnectorProgressDownloadHandler)download;

+ (void)connectWithObject:(id <FTAPIDataAbstractObject>)object andOnCompleteBlock:(FTAPIConnectorCompletionHandler)complete;

- (NSURLRequest *)requestForDataObject:(id <FTAPIDataAbstractObject>)data;


@end
