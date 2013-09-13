//
//  FTAPIConnector.m
//  Cronycle
//
//  Created by Ondrej Rafaj on 12/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIConnector.h"
#import "AFNetworking.h"
#import "FTAccount.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "NSString+URLTools.h"
#import "NSData+Base64.h"


#define kFTAPIConnectorDebug                                    NO
#define kFTAPIConnectorDebugFull                                if (kFTAPIConnectorDebug) 


static AFHTTPClient *_sharedClient = nil;
static FTAccount *_sharedAccount = nil;


@interface FTAPIConnector ()

@end


@implementation FTAPIConnector


#pragma mark Initialization

+ (FTAPIConnector *)sharedConnector {
    static FTAPIConnector *sharedConnector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConnector = [[FTAPIConnector alloc] init];
    });
    
    return sharedConnector;
}

+ (AFHTTPClient *)sharedClient {
    if (!_sharedClient) {
        _sharedClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:_sharedAccount.baseUrl]];
    }
    return _sharedClient;
}

+ (void)resetForAccount:(FTAccount *)account {
    _sharedAccount = account;
    _sharedClient = nil;
    if ([[FTAPIConnector sharedConnector] apiOperatioQueue]) {
        [[[FTAPIConnector sharedConnector] apiOperatioQueue] cancelAllOperations];
    }
    [self sharedClient];
}

- (id)init {
    self = [super init];
    if (self) {
        _apiOperatioQueue = [[NSOperationQueue alloc] init];
        [_apiOperatioQueue setMaxConcurrentOperationCount:3];
    }
    return self;
}

#pragma mark Connections

+ (void)connectWithObject:(id<FTAPIDataAbstractObject>)object withOnCompleteBlock:(FTAPIConnectorCompletionHandler)complete withUploadProgressBlock:(FTAPIConnectorProgressUploadHandler)upload andDownloadProgressBlock:(FTAPIConnectorProgressDownloadHandler)download {
    NSURLRequest *request = [[FTAPIConnector sharedConnector] requestForDataObject:object];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [object processData:JSON];
        [object setResponse:response];
        if (complete) {
            complete(object, nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (complete) {
            complete(object, error);
        }
    }];
    if (upload) {
        [operation setUploadProgressBlock:upload];
    }
    if (download) {
        [operation setDownloadProgressBlock:download];
    }
    
    BOOL authenticate = (kAccountsManager.selectedAccount.username && kAccountsManager.selectedAccount.username.length > 1);
    if (authenticate) {
        [[FTAPIConnector sharedClient] registerHTTPOperationClass:operation.class];
        [[FTAPIConnector sharedClient] clearAuthorizationHeader];
        [[FTAPIConnector sharedClient] setAuthorizationHeaderWithUsername:kAccountsManager.selectedAccount.username password:kAccountsManager.selectedAccount.passwordOrToken];
    }
    
    [[[FTAPIConnector sharedConnector] apiOperatioQueue] addOperation:operation];
}

+ (void)connectWithObject:(id<FTAPIDataAbstractObject>)object withOnCompleteBlock:(FTAPIConnectorCompletionHandler)complete andDownloadProgressBlock:(FTAPIConnectorProgressDownloadHandler)download {
    [self connectWithObject:object withOnCompleteBlock:complete withUploadProgressBlock:nil andDownloadProgressBlock:download];
}

+ (void)connectWithObject:(id<FTAPIDataAbstractObject>)object andOnCompleteBlock:(FTAPIConnectorCompletionHandler)complete {
    [self connectWithObject:object withOnCompleteBlock:complete withUploadProgressBlock:nil andDownloadProgressBlock:nil];
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
    return dataPayload;
}

- (NSURLRequest *)requestForDataObject:(id <FTAPIDataAbstractObject>)data {
   NSDictionary *payload = [data payloadData];
    NSString *url = [NSString stringWithFormat:@"%@%@api/json", [kAccountsManager selectedAccount].baseUrl, [data methodName]];
    if (payload && [data httpMethod] == FTHttpMethodGet) {
        BOOL isQM = !([url rangeOfString:@"?"].location == NSNotFound);
        NSString *par = [NSString stringWithFormat:@"%@%@", (isQM ? @"&" : @"?"), [NSString serializeParams:payload]];
        url = [url stringByAppendingString:par];
    }
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    kFTAPIConnectorDebugFull NSLog(@"Request URL: %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:8.0];
    
    [request setHTTPMethod:[self httpMethod:[data httpMethod]]];
    
    [request setValue:[FTConfig getAppUUID] forHTTPHeaderField:@"X-DeviceId"];
    [request setValue:[UIDevice currentDevice].model forHTTPHeaderField:@"X-DeviceModel"];
    [request setValue:[UIDevice currentDevice].systemVersion forHTTPHeaderField:@"X-DeviceSystemVersion"];
    [request setValue:[UIDevice currentDevice].systemName forHTTPHeaderField:@"X-DeviceSystemName"];
    [request setValue:[UIDevice currentDevice].identifierForVendor.UUIDString forHTTPHeaderField:@"X-DeviceVendorUUID"];
    [request setValue:[self platform] forHTTPHeaderField:@"X-DevicePlatform"];
    [request setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"X-AppBundleShortVersionString"];
    [request setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forHTTPHeaderField:@"X-AppBundleVersion"];
    [request setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] forHTTPHeaderField:@"X-AppBundleIdentifier"];
    
    if ([data httpMethod] == FTHttpMethodPost || [data httpMethod] == FTHttpMethodPut) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        if (payload) {
            NSData *dataPayload = [self processDictionaryIntoDataPayload:payload];
            [request setHTTPBody:dataPayload];
        }
    }
    return request;
}


@end
