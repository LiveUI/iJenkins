//
//  FTHTTPRequestOperation.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 04/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "AFHTTPRequestOperation.h"


@interface FTHTTPRequestOperation : AFHTTPRequestOperation

@property (nonatomic, strong) id <FTAPIDataAbstractObject> dataObject;


@end
