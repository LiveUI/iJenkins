//
//  FTDownload.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 12/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTDownload.h"


@interface FTDownload ()

@property (nonatomic, strong) NSString *safeUrlString;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic) NSInteger repeatedConnectionCounter;
@property (nonatomic) long long totalDataSize;

@property (nonatomic, assign, getter=isOperationStarted) BOOL operationStarted;

@end


@implementation FTDownload

@synthesize executing = _executing;
@synthesize finished = _finished;


#pragma mark Caching

+ (NSString *)folderPath:(FTDownloadCacheLifetime)cacheLifetime withSpecialCacheFolder:(NSString *)specialCacheFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"download-cache-%d", cacheLifetime]];
    if (specialCacheFolder) {
        specialCacheFolder = [self safeText:specialCacheFolder];
        path = [path stringByAppendingPathComponent:specialCacheFolder];
    }
    return path;
}

+ (NSString *)filePath:(FTDownloadCacheLifetime)cacheLifetime withSpecialCacheFolder:(NSString *)specialCacheFolder andFile:(NSString *)specialCacheFile {
    NSString *path = [self folderPath:cacheLifetime withSpecialCacheFolder:specialCacheFolder];
    if (specialCacheFile) {
        return [path stringByAppendingPathComponent:specialCacheFile];
    }
    //else return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"download-cache-%d", cacheLifetime]];
    return path;
}

+ (NSString *)folderPath:(FTDownloadCacheLifetime)cacheLifetime {
    return [self folderPath:cacheLifetime withSpecialCacheFolder:nil];
}

+ (void)clearCache:(FTDownloadCacheLifetime)cacheLifetime {
    // TODO: Clear only when connected to the internet!
    NSString *folderPath = [self folderPath:cacheLifetime];
    BOOL isDir;
    BOOL isFile = [[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDir];
    if (isDir || isFile) {
        NSError *err;
        [[NSFileManager defaultManager] removeItemAtPath:folderPath error:&err];
        if (err && err.code != NSFileNoSuchFileError) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FTLangGet(@"Error") message:[err localizedDescription] delegate:nil cancelButtonTitle:FTLangGet(@"Ok") otherButtonTitles:nil];
            [alert show];
        }
    }
}

+ (NSString *)safeText:(NSString *)text {
	NSString *newText = @"";
	NSString *a;
	for(int i = 0; i < [text length]; i++) {
		a = [text substringWithRange:NSMakeRange(i, 1)];
        NSCharacterSet *unwantedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
		if ([a rangeOfCharacterFromSet:unwantedCharacters].location != NSNotFound) a = @"-";
        newText = [NSString stringWithFormat:@"%@%@", newText, a];
	}
	return newText;
}

- (NSString *)cacheFilePathConstruct {
    //if (_cacheFilePath) return _cacheFilePath;
    NSString *folderPath = [FTDownload folderPath:_cacheLifetime withSpecialCacheFolder:_specialCacheFolder];
    BOOL isDir;
    BOOL isFile = [[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDir];
    if (!isFile || !isDir) {
        NSError *err;
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&err];
        if (err) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:FTLangGet(@"Error") message:[err localizedDescription] delegate:nil cancelButtonTitle:FTLangGet(@"Ok") otherButtonTitles:nil];
            [alert show];
            return nil;
        }
    }
    NSString *scf = _specialCacheFile;
    if (!_specialCacheFile) {
        scf = _safeUrlString;
    }
    return [FTDownload filePath:_cacheLifetime withSpecialCacheFolder:_specialCacheFolder andFile:scf];
}

+ (BOOL)isFileForUrlString:(NSString *)urlPath andCacheLifetime:(FTDownloadCacheLifetime)cacheLifetime {
    NSString *path = [self filePath:cacheLifetime withSpecialCacheFolder:nil andFile:[self safeText:urlPath]];
    BOOL isFile = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return isFile;
}

+ (NSString *)fileForUrlString:(NSString *)urlPath andCacheLifetime:(FTDownloadCacheLifetime)cacheLifetime {
    return [self filePath:cacheLifetime withSpecialCacheFolder:nil andFile:[self safeText:urlPath]];
}

#pragma mark Initialization

- (id)initWithURL:(NSString *)urlPath cacheLifetime:(FTDownloadCacheLifetime)lifetime success:(void (^)(NSData *data))successBlock failure:(void (^)(NSError* error))failureBlock progress:(void (^)(CGFloat progress))progressBlock {
    self = [super init];
    if (self) {
        _connectionURL = urlPath;
        _safeUrlString = [FTDownload safeText:_connectionURL];
        _postParameters = nil;
        _successBlock = successBlock;
        _failureBlock = failureBlock;
        _progressBlock = progressBlock;
        _cacheLifetime = lifetime;
    }
    return self;
}

- (id)initWithURL:(NSString *)urlPath withDelegate:(id <FTDownloadDelegate>)delegate andCacheLifetime:(FTDownloadCacheLifetime)lifetime {
    self = [super init];
    if (self) {
        _connectionURL = urlPath;
        _safeUrlString = [FTDownload safeText:_connectionURL];
        _postParameters = nil;
        _delegate = delegate;
        _cacheLifetime = lifetime;
    }
    return self;
}

- (id)initWithURL:(NSString *)urlPath withPostParameters:(NSMutableDictionary *)postParameters withDelegate:(id <FTDownloadDelegate>)delegate andCacheLifetime:(FTDownloadCacheLifetime)lifetime {
    self = [super init];
    if (self) {
        _connectionURL = urlPath;
        _safeUrlString = [FTDownload safeText:_connectionURL];
        _postParameters = postParameters;
        _delegate = delegate;
        _cacheLifetime = lifetime;
    }
    return self;
}

- (id)initWithURL:(NSString *)urlPath withPostParameters:(NSMutableDictionary *)postParameters andUrlConnectionDelegate:(id<NSURLConnectionDelegate,NSURLConnectionDataDelegate>)delegate {
    self = [super init];
    if (self) {
        _connectionURL = urlPath;
        _safeUrlString = [FTDownload safeText:_connectionURL];
        _postParameters = postParameters;
        _connectionDelegate = delegate;
    }
    return self;
}

#pragma mark Operation methods

- (void)done {
    if (![self isOperationStarted]) return;
    if(_connection) {
        [_connection cancel];
        _connection = nil;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    _executing = NO;
    _finished = YES;
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)cancel {
    [self done];
}

- (void)start {
    [self setOperationStarted:YES];
    
    if(![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if(_finished || [self isCancelled]) {
        [self done];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self main];
}

- (void)main {
    @autoreleasepool {
        _safeUrlString = [FTDownload safeText:_connectionURL];
        _cacheFilePath = [self cacheFilePathConstruct];
        if ([[NSFileManager defaultManager] fileExistsAtPath:_cacheFilePath] && _cacheLifetime != FTDownloadCacheLifetimeNone) {
            NSData *data = [NSData dataWithContentsOfFile:_cacheFilePath];
            if ([_delegate respondsToSelector:@selector(download:didFinishLoadingWithData:)]) {
                [_delegate download:self didFinishLoadingWithData:data];
            }
            [self done];
        }
        else {
            NSURL *url = [[NSURL alloc] initWithString:_connectionURL];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
            [request setTimeoutInterval:8];
            if (_postParameters) {
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_postParameters options:NSJSONWritingPrettyPrinted error:&error];
                NSString *requestJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                NSLog(@"JSONRequest: %@", requestJSON);
                
                NSData *requestData = [NSData dataWithBytes:[requestJSON UTF8String] length:[requestJSON length]];
                [request setHTTPMethod:@"POST"];
                [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:requestData];
            }
            _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        }
    }
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}

#pragma mark Connection delegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if ([_connectionDelegate respondsToSelector:@selector(connection:didFailWithError:)]) {
        [_connectionDelegate connection:connection didFailWithError:error];
    }
    if ([_delegate respondsToSelector:@selector(download:didFinishLoadingWithError:)]) {
        [_delegate download:self didFinishLoadingWithError:error];
    }

    if (_failureBlock) {
        _failureBlock(error);
    }
    
    [self done];
        
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([_connectionDelegate respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        [_connectionDelegate connection:connection didReceiveResponse:response];
    }
    else {
        _totalDataSize = response.expectedContentLength;
        _receivedData = [NSMutableData data];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if ([_connectionDelegate respondsToSelector:@selector(connection:didReceiveData:)]) {
        [_connectionDelegate connection:connection didReceiveData:data];
    }
    else {
        [_receivedData appendData:data];
        
        CGFloat progressPercentage = 0.f;
        if (_totalDataSize != NSURLResponseUnknownLength && _totalDataSize != 0) progressPercentage = (([_receivedData length] * 100.0f) / (float)_totalDataSize);
        if (progressPercentage > 100.0f) progressPercentage = 100.0f;
        
        if ([_delegate respondsToSelector:@selector(download:didUpdatePercentageProgressStatus:)]) {
            [_delegate download:self didUpdatePercentageProgressStatus:progressPercentage];
        }
        if (_progressBlock) {
            _progressBlock(progressPercentage);
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if ([_connectionDelegate respondsToSelector:@selector(connectionDidFinishLoading:)]) {
        [_connectionDelegate connectionDidFinishLoading:connection];
    }
    if ([_delegate respondsToSelector:@selector(download:didFinishLoadingWithData:)]) {
        if (_cacheLifetime != FTDownloadCacheLifetimeNone) {
            [_receivedData writeToFile:_cacheFilePath atomically:YES];
        }
        [_delegate download:self didFinishLoadingWithData:_receivedData];
    }
    if (_successBlock) {
        if (_cacheLifetime != FTDownloadCacheLifetimeNone) {
            [_receivedData writeToFile:_cacheFilePath atomically:YES];
        }
        _successBlock(_receivedData);
    }
    [self done];
}


@end
