//
//  FTAPIConnector.h
//  Cronycle
//
//  Created by Ondrej Rafaj on 12/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTAPIJobsDataObject.h"


#define kAPIConnector                                       [FTAPIConnector connectorWithDelegate:self]


@class FTAPIConnector;

@protocol FTAPIConnectorDelegate <NSObject>

- (void)apiConnector:(FTAPIConnector *)connector didFinishWithData:(FTAPIDataObject *)data;
- (void)apiConnector:(FTAPIConnector *)connector didFinishWithError:(NSError *)error;

@end


typedef void(^FTAPIConnectorCompletionHandler) (id <FTAPIDataAbstractObject> dataObject, NSError *error);


@interface FTAPIConnector : NSObject

@property (nonatomic, strong, readonly) FTAPIDataObject *dataObject;

@property (nonatomic, strong, readonly) NSURLConnection *connection;
@property (nonatomic, strong, readonly) NSString *url;
@property (nonatomic, readonly) NSInteger statusCode;
@property (nonatomic, readonly) BOOL receivedMessageOK;
@property (nonatomic, strong, readonly) NSDictionary *receivedJsonData;

@property (nonatomic, readonly) NSInteger repeatedConnectionCounter;

@property (nonatomic, assign) id <FTAPIConnectorDelegate> delegate;

+ (id)connectorWithDelegate:(id <FTAPIConnectorDelegate>)delegate;
+ (void)connectWithObject:(id <FTAPIDataAbstractObject>)object andOnCompleteBlock:(FTAPIConnectorCompletionHandler)complete;

- (void)startConnectionWithData:(id <FTAPIDataAbstractObject>)data;
- (NSURLRequest *)requestForDataObject:(id <FTAPIDataAbstractObject>)data;


@end
