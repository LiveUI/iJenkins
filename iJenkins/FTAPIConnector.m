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

@property (nonatomic, strong) AFHTTPSessionManager *jsonManager;
@property (nonatomic, strong) AFHTTPSessionManager *textManager;

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

- (void)stopLoadingAll {
    
}

- (void)resetForAccount:(FTAccount *)account {
    _sharedAccount = account;
    [self stopLoadingAll];
}

- (id)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.jsonManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        self.textManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        AFHTTPResponseSerializer *serializer = [[AFHTTPResponseSerializer alloc] init];
        [self.textManager setResponseSerializer:serializer];
        
        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [policy setValidatesDomainName:NO];
        [policy setAllowInvalidCertificates:YES];
        [self.jsonManager setSecurityPolicy:policy];
        [self.textManager setSecurityPolicy:policy];
    }
    return self;
}

#pragma mark Connections

- (void)connectWithObject:(id<FTAPIDataAbstractObject>)object withOnCompleteBlock:(FTAPIConnectorCompletionHandler)complete withUploadProgressBlock:(FTAPIConnectorProgressUploadHandler)upload andDownloadProgressBlock:(FTAPIConnectorProgressDownloadHandler)download {
    NSURLRequest *request = [[FTAPIConnector sharedConnector] requestForDataObject:object];
    AFHTTPSessionManager *manager = (object.outputType == FTAPIDataObjectOutputTypeJSON) ? self.jsonManager : self.textManager;
    NSURLSessionDataTask *downloadTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
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
    
    BOOL authenticate = ([FTAccountsManager sharedManager].selectedAccount.username && [FTAccountsManager sharedManager].selectedAccount.username.length > 1);
    if (authenticate) {
        [self.jsonManager.requestSerializer clearAuthorizationHeader];
        [self.jsonManager.requestSerializer setAuthorizationHeaderFieldWithUsername:[FTAccountsManager sharedManager].selectedAccount.username password:[FTAccountsManager sharedManager].selectedAccount.passwordOrToken];
        [self.textManager.requestSerializer clearAuthorizationHeader];
        [self.textManager.requestSerializer setAuthorizationHeaderFieldWithUsername:[FTAccountsManager sharedManager].selectedAccount.username password:[FTAccountsManager sharedManager].selectedAccount.passwordOrToken];
    }
    
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
