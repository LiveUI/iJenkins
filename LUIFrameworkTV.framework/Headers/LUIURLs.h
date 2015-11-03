//
//  LUIURLs.h
//
//  Created by Ondrej Rafaj on 27/05/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LUIURLs : NSObject

/**
 *  Instance of LUIURLs
 *
 *  @note Use instead any -init methods, if you use -init, your app will crash
 *
 *  @return LUIURLs instance of this object
 */
+ (instancetype)sharedInstance;

/**
 *  Set your own API url
 *
 *  @note For enterprise implementations where data is hosted on clients servers
 */
@property (nonatomic, strong) NSString *customApiUrlString;

/**
 *  Set your own Assets/CDN url
 *
 *  @note For enterprise implementations where data is hosted on clients servers
 */
@property (nonatomic, strong) NSString *customAssetsUrlString;


@end
