//
//  FTDownload.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 12/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


typedef enum {
    FTDownloadCacheLifetimeNone,
    FTDownloadCacheLifetimeForever,
    FTDownloadCacheLifetimeSession,
    FTDownloadCacheLifetimeTerminate
} FTDownloadCacheLifetime;


@class FTDownload;

@protocol FTDownloadDelegate <NSObject>

@required
- (void)download:(FTDownload *)download didFinishLoadingWithData:(NSData *)data;

@optional
- (void)download:(FTDownload *)download didFinishLoadingWithError:(NSError *)error;
- (void)download:(FTDownload *)download didUpdatePercentageProgressStatus:(CGFloat)percentage;

@end


@interface FTDownload : NSOperation <NSURLConnectionDelegate>


@property (nonatomic, strong) NSString *connectionURL;
@property (nonatomic, strong) NSDictionary *postParameters;

@property (readonly, getter = isExecuting) BOOL executing;
@property (readonly, getter = isFinished) BOOL finished;

@property (nonatomic, strong) NSString *specialCacheFolder;
@property (nonatomic, strong) NSString *specialCacheFile;
@property (nonatomic, strong, readonly) NSString *cacheFilePath;

@property (nonatomic, readonly) FTDownloadCacheLifetime cacheLifetime;
@property (nonatomic, strong, readonly) NSURLConnection *connection;

@property (nonatomic, weak, readonly) id <NSURLConnectionDelegate, NSURLConnectionDataDelegate> connectionDelegate;
@property (nonatomic, weak, readonly) id <FTDownloadDelegate> delegate;

@property (nonatomic) SEL unitTestSelector;

@property (nonatomic, copy) void (^successBlock)(NSData *data);
@property (nonatomic, copy) void (^failureBlock)(NSError* error);
@property (nonatomic, copy) void (^progressBlock)(CGFloat p);

- (id)initWithURL:(NSString *)urlPath cacheLifetime:(FTDownloadCacheLifetime)lifetime success:(void (^)(NSData *data))success failure:(void (^)(NSError* error))failure progress:(void (^)(CGFloat p))progress;

- (id)initWithURL:(NSString *)urlPath withDelegate:(id <FTDownloadDelegate>)delegate andCacheLifetime:(FTDownloadCacheLifetime)lifetime;
- (id)initWithURL:(NSString *)urlPath withPostParameters:(NSMutableDictionary *)postParameters withDelegate:(id <FTDownloadDelegate>)delegate andCacheLifetime:(FTDownloadCacheLifetime)lifetime;
- (id)initWithURL:(NSString *)urlPath withPostParameters:(NSMutableDictionary *)postParameters andUrlConnectionDelegate:(id <NSURLConnectionDelegate, NSURLConnectionDataDelegate>)delegate;

- (BOOL)isConcurrent;
- (BOOL)isExecuting;
- (BOOL)isFinished;

- (void)cancel;

+ (NSString *)folderPath:(FTDownloadCacheLifetime)cacheLifetime withSpecialCacheFolder:(NSString *)specialCacheFolder;
+ (NSString *)filePath:(FTDownloadCacheLifetime)cacheLifetime withSpecialCacheFolder:(NSString *)specialCacheFolder andFile:(NSString *)specialCacheFile;
+ (void)clearCache:(FTDownloadCacheLifetime)cacheLifetime;
+ (NSString *)safeText:(NSString *)text;

+ (BOOL)isFileForUrlString:(NSString *)urlPath andCacheLifetime:(FTDownloadCacheLifetime)cacheLifetime;
+ (NSString *)fileForUrlString:(NSString *)urlPath andCacheLifetime:(FTDownloadCacheLifetime)cacheLifetime;


@end
