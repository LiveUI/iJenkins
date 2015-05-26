//
//  FTAPIBuildConsoleOutputDataObject.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 04/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIBuildConsoleOutputDataObject.h"


@implementation FTAPIBuildConsoleOutputDataObject


#pragma mark Object implementation

- (FTHttpMethod)httpMethod {
    return FTHttpMethodGet;
}

- (NSString *)methodName {
    return [NSString stringWithFormat:@"job/%@/%ld/consoleText", _jobName, (long)_buildNumber];
}

- (NSDictionary *)payloadData {
    return nil;
}

- (void)processText:(NSString *)text {
    [super processText:text];
    _outputText = text;
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

- (NSInteger)depth {
    return 1;
}

- (FTAPIDataObjectOutputType)outputType {
    return FTAPIDataObjectOutputTypePlainText;
}

#pragma mark Initialization

- (id)initWithJobName:(NSString *)jobName andBuildNumber:(NSInteger)buildNumber {
    self = [super init];
    if (self) {
        _jobName = jobName;
        _buildNumber = buildNumber;
    }
    return self;
}


@end
