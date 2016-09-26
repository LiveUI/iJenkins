//
//  FTAPIRestartDataObject.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 03/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTAPIDataObject.h"


typedef NS_ENUM(NSInteger, FTAPIRestartDataObjectType) {
    FTAPIRestartDataObjectTypeSafeRestart,
    FTAPIRestartDataObjectTypeRestart,
    FTAPIRestartDataObjectTypeQuietDown,
    FTAPIRestartDataObjectTypeCancelQuietDown
};


@interface FTAPIRestartDataObject : FTAPIDataObject <FTAPIDataAbstractObject>

@property (nonatomic, readonly) FTAPIRestartDataObjectType restartType;

- (id)initWithRestartType:(FTAPIRestartDataObjectType)type;


+ (FTAPIRestartDataObjectType)typeWithString:(NSString *)string;

@end
