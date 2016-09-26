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
        case FTAPIRestartDataObjectTypeCancelQuietDown:
            return @"cancelQuietDown";
            break;
            
        case FTAPIRestartDataObjectTypeQuietDown:
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


#pragma mark Class methods

+ (FTAPIRestartDataObjectType)typeWithString:(NSString *)string
{
    FTAPIRestartDataObjectType type;
    
    if ([string isEqualToString:@"safeRestart"]) {
        type = FTAPIRestartDataObjectTypeSafeRestart;
    } else if([string isEqualToString:@"restart"]) {
        type = FTAPIRestartDataObjectTypeRestart;
    } else if ([string isEqualToString:@"quietDown"]) {
        type = FTAPIRestartDataObjectTypeQuietDown;
    } else if ([string isEqualToString:@"cancelQuietDown"]) {
        type = FTAPIRestartDataObjectTypeCancelQuietDown;
    } else {
        type = 0;   //  Unknown value, first item in enum by default
    }
    
    return type;
}

@end
