//
//  FTAPIConnector.m
//  Cronycle
//
//  Created by Ondrej Rafaj on 12/08/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTAPIConnector.h"
#import "AFNetworking.h"
#import "FTJSONRequestOperation.h"
#import "FTHTTPRequestOperation.h"
#import "FTAccount.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "NSString+URLTools.h"
#import "NSData+Base64.h"


#define dFTAPIConnectorDebug                                    YES
#define dFTAPIConnectorDebugFull                                if (dFTAPIConnectorDebug) 


//static AFHTTPClient *_sharedClient = nil;
static FTAccount *_sharedAccount = nil;


@interface FTAPIConnector ()

@property (nonatomic, strong) AFURLSessionManager *manager;

@end


@implementation FTAPIConnector


#pragma mark Initialization

+ (FTAPIConnector *)sharedConnector {
    static FTAPIConnector *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[FTAPIConnector alloc] init];
    });
    return shared;
}

//+ (AFHTTPClient *)sharedClient {
//    if (!_sharedClient) {
//        _sharedClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:_sharedAccount.baseUrl]];
//    }
//    return _sharedClient;
//}

- (void)stopLoadingAll {
    
}

- (void)resetForAccount:(FTAccount *)account {
    _sharedAccount = account;
//    _sharedClient = nil;
    [self stopLoadingAll];
//    [self sharedClient];
}

- (id)init {
    self = [super init];
    if (self) {
        //_apiOperationQueue = [[NSOperationQueue alloc] init];
        //[_apiOperationQueue setMaxConcurrentOperationCount:3];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [policy setValidatesDomainName:NO];
        [policy setAllowInvalidCertificates:YES];
        [self.manager setSecurityPolicy:policy];
    }
    return self;
}

#pragma mark Connections

- (void)connectWithObject:(id<FTAPIDataAbstractObject>)object withOnCompleteBlock:(FTAPIConnectorCompletionHandler)complete withUploadProgressBlock:(FTAPIConnectorProgressUploadHandler)upload andDownloadProgressBlock:(FTAPIConnectorProgressDownloadHandler)download {
    
    
    NSURLRequest *request = [[FTAPIConnector sharedConnector] requestForDataObject:object];
    NSURLSessionDataTask *downloadTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        [object processHeaders:httpResponse.allHeaderFields];
        [object setResponse:httpResponse];
        if (!error) {
            if ([object outputType] == FTAPIDataObjectOutputTypeJSON) {
                [object processData:responseObject];
            }
            else if ([responseObject isKindOfClass:[NSData class]]) {
                NSString *text = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                [object processText:text];
            }
            else if ([responseObject isKindOfClass:[NSString class]]) {
                [object processText:responseObject];
            }
        }
        if (complete) {
            complete(object, error);
        }
    }];
    [downloadTask resume];
    
    /*
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"application/javascript", nil]];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    NSURLRequest *request = [[FTAPIConnector sharedConnector] requestForDataObject:object];
    id operation = nil;
    if ([object outputType] == FTAPIDataObjectOutputTypeJSON) {
        FTJSONRequestOperation *o = [FTJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [object processHeaders:response.allHeaderFields];
            [object processData:JSON];
            [object setResponse:response];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            if (complete) {
                complete(object, nil);
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [object processHeaders:response.allHeaderFields];
            [object setResponse:response];
            if (complete) {
                complete(object, error);
            }
        }];
        operation = o;
    }
    else {
        FTHTTPRequestOperation *o = [[FTHTTPRequestOperation alloc] initWithRequest:request];
        [o setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [object processHeaders:operation.response.allHeaderFields];
            NSString *text = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            [object processText:text];
            [object setResponse:operation.response];
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            if (complete) {
                complete(object, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
            [object processHeaders:operation.response.allHeaderFields];
            [object setResponse:operation.response];
            if (complete) {
                complete(object, error);
            }
        }];
        operation = o;
    }
    [operation setDataObject:object];
    if (upload) {
        [operation setUploadProgressBlock:upload];
    }
    if (download) {
        [operation setDownloadProgressBlock:download];
    }
    
    [operation setAllowsInvalidSSLCertificate:YES];
    
    [operation setQueuePriority:[object queuePriority]];
    
    [[[FTAPIConnector sharedConnector] apiOperationQueue] addOperation:operation];
     
    //*/
    
}

- (void)connectWithObject:(id<FTAPIDataAbstractObject>)object withOnCompleteBlock:(FTAPIConnectorCompletionHandler)complete andDownloadProgressBlock:(FTAPIConnectorProgressDownloadHandler)download {
    [self connectWithObject:object withOnCompleteBlock:complete withUploadProgressBlock:nil andDownloadProgressBlock:download];
}

- (void)connectWithObject:(id<FTAPIDataAbstractObject>)object andOnCompleteBlock:(FTAPIConnectorCompletionHandler)complete {
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
    NSString *url = [NSString stringWithFormat:@"%@/%@%@", [[FTAccountsManager sharedManager] selectedAccount].baseUrl, [data methodName], [data suffix]];
    if (payload && [data httpMethod] == FTHttpMethodGet) {
        BOOL isQM = !([url rangeOfString:@"?"].location == NSNotFound);
        NSString *par = [NSString stringWithFormat:@"%@%@", (isQM ? @"&" : @"?"), [NSString serializeParams:payload]];
        url = [url stringByAppendingString:par];
    }
    BOOL isQM = !([url rangeOfString:@"?"].location == NSNotFound);
    url = [NSString stringWithFormat:@"%@%@depth=%ld", url, (isQM ? @"&" : @"?"), (long)data.depth];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dFTAPIConnectorDebugFull NSLog(@"Request URL: %@", url);
    
//    BOOL authenticate = ([FTAccountsManager sharedManager].selectedAccount.username && [FTAccountsManager sharedManager].selectedAccount.username.length > 1);
//    if (authenticate) {
//        [[FTAPIConnector sessionManager] clearAuthorizationHeader];
//        [[FTAPIConnector sharedClient] setAuthorizationHeaderWithUsername:[FTAccountsManager sharedManager].selectedAccount.username password:[FTAccountsManager sharedManager].selectedAccount.passwordOrToken];
//    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSTimeInterval timeout = [FTAccountsManager sharedManager].selectedAccount.timeout;
    if (timeout < 1.5) timeout = 8;
    [request setTimeoutInterval:timeout];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    
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
