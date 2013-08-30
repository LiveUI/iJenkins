//
//  FTAPIConnector.m
//  Cronycle
//
//  Created by Ondrej Rafaj on 12/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIConnector.h"
#import "FTAccountsManager.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "NSString+URLTools.h"
#import "NSData+Base64.h"


#define kFTAPIConnectorDebug                                    NO
#define kFTAPIConnectorDebugFull                                if (kFTAPIConnectorDebug) 


@interface FTAPIConnector ()

@property (nonatomic, strong, readonly) NSMutableData *receivedData;
@property (nonatomic, strong, readonly) NSString *receivedString;

@end


@implementation FTAPIConnector


#pragma mark Initialization

+ (id)connectorWithDelegate:(id<FTAPIConnectorDelegate>)delegate {
    FTAPIConnector *conn = [[FTAPIConnector alloc] init];
    [conn setDelegate:delegate];
    return conn;
}

#pragma mark Connections

+ (void)connectWithObject:(id<FTAPIDataAbstractObject>)object andOnCompleteBlock:(FTAPIConnectorCompletionHandler)complete {
    __block FTAPIConnector *conn = [[FTAPIConnector alloc] init];
    NSURLRequest *request = [conn requestForDataObject:object];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [conn connection:nil didReceiveResponse:response];
        [conn connection:nil didReceiveData:data];
        if (error) {
            [conn connection:nil didFailWithError:error];
        }
        else {
            [conn connectionDidFinishLoading:nil];
        }
        if (!error && [(FTAPIDataObject *)object apiErrors]) {
            //error = [FTAPIConnector getAPIError];
        }
        if (complete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(object, error);
            });
        }
    }];
}

- (NSString *)httpMethod:(FTHttpMethod)method {
    NSString *m;
    switch (method) { 
        case FTHttpMethodGet:
            m = @"GET";
            break;
            
        case FTHttpMethodPost:
            m = @"POST";
            break;
            
        case FTHttpMethodPut:
            m = @"PUT";
            break;
            
        case FTHttpMethodDelete:
            m = @"DELETE";
            break;
            
        default:
            m = @"GET";
    }
    return m;
}

- (NSString *)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

- (NSData *)processDictionaryIntoDataPayload:(NSDictionary *)dictionary {
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    NSError *err;
    NSData *dataPayload = [NSJSONSerialization dataWithJSONObject:d options:NSJSONWritingPrettyPrinted error:&err];
    if (err) {
        //WFErrorLogError(err);
    }
    return dataPayload;
}

- (NSString *)authString {
    if (kAccountsManager.selectedAccount.username) {
        NSString *authStr = [NSString stringWithFormat:@"%@:%@", kAccountsManager.selectedAccount.username, kAccountsManager.selectedAccount.password];
        NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
        return [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength]];
    }
    else return nil;
}

- (NSURLRequest *)requestForDataObject:(id <FTAPIDataAbstractObject>)data {
    _dataObject = data;
    NSDictionary *payload = [data payloadData];
    NSString *url = [NSString stringWithFormat:@"http://www.fuerteserver.com:8800/%@api/json", [data methodName]];
    if (payload && [data httpMethod] == FTHttpMethodGet) {
        BOOL isQM = !([url rangeOfString:@"?"].location == NSNotFound);
        NSString *par = [NSString stringWithFormat:@"%@%@", (isQM ? @"&" : @"?"), [NSString serializeParams:payload]];
        url = [url stringByAppendingString:par];
    }
    _url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    kFTAPIConnectorDebugFull NSLog(@"Request URL: %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:8.0];
    
    NSString *auth = [self authString];
    if (auth) {
        [request setValue:auth forHTTPHeaderField:@"Authorization"];
    }
    
    [request setHTTPMethod:[self httpMethod:[data httpMethod]]];
    if ([data httpMethod] == FTHttpMethodPost || [data httpMethod] == FTHttpMethodPut) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        if (payload) {
            NSData *dataPayload = [self processDictionaryIntoDataPayload:payload];
            [request setHTTPBody:dataPayload];
        }
    }
    return request;
}

-  (void)startConnectionWithData:(id <FTAPIDataAbstractObject>)data {
    NSURLRequest *request = [self requestForDataObject:data];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    _connection = connection;
    _repeatedConnectionCounter++;
}

#pragma mark Connection delgate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _receivedData = [NSMutableData data];
    _statusCode = [(NSHTTPURLResponse *)response statusCode];
    [_dataObject setResponseStatusCode:_statusCode];
    [_dataObject processHeaders:[(NSHTTPURLResponse *)response allHeaderFields]];
    kFTAPIConnectorDebugFull NSLog(@"Connection headers: %@", [(NSHTTPURLResponse *)response allHeaderFields]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [_dataObject setConnectionError:error];
    if (_repeatedConnectionCounter <= 1) {
        [self startConnectionWithData:(id <FTAPIDataAbstractObject>)_dataObject];
    }
    else {
        if ([_delegate respondsToSelector:@selector(apiConnector:didFinishWithError:)]) {
            [_delegate apiConnector:self didFinishWithError:error];
        }
    }
    kFTAPIConnectorDebugFull NSLog(@"Connection error number %d: %@ in URL: %@", _repeatedConnectionCounter, [error localizedDescription], _url);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *dataString = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
    _receivedString = dataString;
    NSError *err;
    _receivedJsonData = [NSJSONSerialization JSONObjectWithData:_receivedData options:NSJSONReadingMutableLeaves error:&err];
    if (err) {
        //WFErrorLogError(err);
    }
    if (kFTAPIConnectorDebug || _dataObject.printOutputToConsole) NSLog(@"Received JSON data: %@", _receivedJsonData);
    _receivedMessageOK = _receivedJsonData ? YES : NO;
    if (_receivedJsonData) [_dataObject processData:_receivedJsonData];
    if (_dataObject.apiErrors) {
        if ([_delegate respondsToSelector:@selector(apiConnector:didFinishWithError:)]) {
            //[_delegate apiConnector:self didFinishWithError:[FTAPIConnector getAPIError]];
        }
    }
    else {
        if ([_delegate respondsToSelector:@selector(apiConnector:didFinishWithData:)]) {
            [_delegate apiConnector:self didFinishWithData:_dataObject];
        }
    }
}


@end
