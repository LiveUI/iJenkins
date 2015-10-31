//
//  FTJSONRequestOperation.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 13/09/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//


@interface FTJSONRequestOperation : AFHTTPRequestSerializer

@property (nonatomic, strong) id <FTAPIDataAbstractObject> dataObject;


@end
