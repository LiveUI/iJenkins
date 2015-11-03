//
//  LUIDebugger.h
//
//  Created by Ondrej Rafaj on 15/06/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import "LUIBasicData.h"

/**
 *  Remotely tracked log
 *
 *  @note   You can use this instead of NSLog()
 *
 *  @param args... Multiple arguments to be logged
 */
#define LUILog(args...)                LUILogFull(__FILE__, __LINE__, __PRETTY_FUNCTION__, args)

/**
 *  Please use LUILog(args...) instead
 */
FOUNDATION_EXPORT void LUILogFull(const char *file, int line, const char *function, NSString *format, ...);


@interface LUIDebugger : LUIBasicData

/**
 *  Enable remote logging from code
 * 
 *  @note Any settings from admin panel will override this for ever
 *  @note This is useful if you want to enable logging right away, before any configuration can be loaded from LiveUI
 */
@property (nonatomic) BOOL loggingEnabled;

/**
 *  Instance of LUIDebugger
 *
 *  @note Use instead any -init methods, if you use -init, your app will crash
 *
 *  @return LUIDebugger instance of this object
 */
+ (instancetype)sharedInstance;


@end
