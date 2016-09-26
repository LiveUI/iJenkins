//
//  FTAPIPluginManagerDataObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 10/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIPluginManagerDataObject.h"


@implementation FTAPIPluginManagerDataObject


#pragma mark Object implementation

- (FTHttpMethod)httpMethod {
    return FTHttpMethodGet;
}

- (NSString *)methodName {
    return @"pluginManager/";
}

- (NSDictionary *)payloadData {
    return nil;
}

- (void)processData:(NSDictionary *)data {
    [super processData:data];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *d in data[@"plugins"]) {
        FTAPIPluginManagerPluginDataObject *plugin = [[FTAPIPluginManagerPluginDataObject alloc] init];
        [plugin processData:d];
        [arr addObject:plugin];
    }
    _plugins = [arr copy];
}

- (NSInteger)depth {
    return 2;
}


@end


@implementation FTAPIPluginManagerPluginDataObject

#pragma mark Data

- (void)processData:(NSDictionary *)data {
    _active = [data[@"active"] boolValue];
    _backupVersion = data[@"backupVersion"];
    _bundled = [data[@"bundled"] boolValue];
    _deleted = [data[@"deleted"] boolValue];
    if (data[@"dependencies"] && ([data[@"dependencies"] count] > 0)) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *d in data[@"dependencies"]) {
            FTAPIPluginManagerPluginDependencyDataObject *dependency = [[FTAPIPluginManagerPluginDependencyDataObject alloc] init];
            [dependency processData:d];
            [arr addObject:dependency];
        }
        _dependencies = [arr copy];
    }
    else _dependencies = nil;
    _downgradable = [data[@"downgradable"] boolValue];
    _enabled = [data[@"enabled"] boolValue];
    _hasUpdate = [data[@"hasUpdate"] boolValue];
    _longName = data[@"longName"];
    _pinned = [data[@"pinned"] boolValue];
    _shortName = data[@"shortName"];
    _supportsDynamicLoad = data[@"supportsDynamicLoad"];
    _urlString = data[@"url"];
    _version = data[@"version"];
}


@end


@implementation FTAPIPluginManagerPluginDependencyDataObject

#pragma mark Data

- (void)processData:(NSDictionary *)data {
    _optional = [data[@"optional"] boolValue];
    _shortName = data[@"shortName"];
    _version = data[@"version"];
}


@end
