//
//  FTAPIRestartDataObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 03/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIRestartDataObject.h"


@implementation FTAPIRestartDataObject


#pragma mark Object implementation

- (FTHttpMethod)httpMethod {
    return FTHttpMethodGet;
}

- (NSString *)methodName {
    switch (_restartType) {
        case FTAPIRestartDataObjectTypeCancelQuiteDown:
            return @"cancelQuietDown";
            break;
            
        case FTAPIRestartDataObjectTypeQuiteDown:
            return @"quietDown";
            break;
            
        case FTAPIRestartDataObjectTypeRestart:
            return @"restart";
            break;
            
        case FTAPIRestartDataObjectTypeSafeRestart:
            return @"safeRestart";
            break;
            
        default:
            return nil;
            break;
    }
}

- (NSDictionary *)payloadData {
    return nil;
}

- (void)processData:(NSDictionary *)data {
    [super processData:data];
}

- (void)processHeaders:(NSDictionary *)headers {
    [super processHeaders:headers];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityVeryHigh;
}

- (NSString *)suffix {
    return @"";
}

#pragma mark Initialization

- (id)initWithRestartType:(FTAPIRestartDataObjectType)type {
    self = [super init];
    if (self) {
        _restartType = type;
    }
    return self;
}


@end
