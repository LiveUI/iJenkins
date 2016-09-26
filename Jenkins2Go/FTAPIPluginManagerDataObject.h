//
//  FTAPIPluginManagerDataObject.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 10/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIDataObject.h"


@interface FTAPIPluginManagerDataObject : FTAPIDataObject <FTAPIDataAbstractObject>

@property (nonatomic, readonly) NSArray *plugins; // Array of FTAPIPluginManagerPluginDataObject objects


@end


@interface FTAPIPluginManagerPluginDataObject : NSObject

@property (nonatomic, readonly) BOOL active;
@property (nonatomic, readonly) NSString *backupVersion;
@property (nonatomic, readonly) BOOL bundled;
@property (nonatomic, readonly) BOOL deleted;
@property (nonatomic, readonly) NSArray *dependencies; // Array of FTAPIPluginManagerPluginDependencyDataObject objects
@property (nonatomic, readonly) BOOL downgradable;
@property (nonatomic, readonly) BOOL enabled;
@property (nonatomic, readonly) BOOL hasUpdate;
@property (nonatomic, readonly) NSString *longName;
@property (nonatomic, readonly) BOOL pinned;
@property (nonatomic, readonly) NSString *shortName;
@property (nonatomic, readonly) NSString *supportsDynamicLoad;
@property (nonatomic, readonly) NSString *urlString;
@property (nonatomic, readonly) NSString *version;

- (void)processData:(NSDictionary *)data;


@end


@interface FTAPIPluginManagerPluginDependencyDataObject : NSObject

@property (nonatomic, readonly) BOOL optional;
@property (nonatomic, readonly) NSString *shortName;
@property (nonatomic, readonly) NSString *version;

- (void)processData:(NSDictionary *)data;


@end