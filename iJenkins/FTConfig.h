//
//  FTConfig.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 29/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum {
    FTHttpMethodGet,
    FTHttpMethodPost,
    FTHttpMethodDelete,
    FTHttpMethodPut
} FTHttpMethod;



@interface FTConfig : NSObject

+ (NSString *)getAppUUID;


@end
