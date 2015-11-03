//
//  LUIImages.h
//
//  Created by Ondrej Rafaj on 24/04/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

#elif TARGET_OS_MAC

#import <Cocoa/Cocoa.h>

#endif

#import "LUIBasicData.h"

/**
 *  Notification that will be fired when visuals (colors, images, etc ...) are updated
 *
 *  @note You can use this for example to reload the interface
 */
extern NSString *const LUIVisualsDidUpdateContentNotification;

/**
 *  Return image
 *
 *  @param key key for an image that has been been setup in your admin panel
 *
 *  @return UIImage/NSImage image
 */
#define LUIImage(key)                                   [LUIVisuals imageWithKey:key]

/**
 *  Return color
 *
 *  @param key key for an image that has been been setup in your admin panel
 *
 *  @return UIColor/NSColor color
 */
#define LUIColor(key)                                   [LUIVisuals colorWithKey:key]


@interface LUIVisuals : LUIBasicData

/**
 *  Instance of LUIVisuals
 *
 *  @note Use instead any -init methods, if you use -init, your app will crash
 *
 *  @return LUIVisuals instance of this object
 */
+ (instancetype)sharedInstance;

/**
 *  Return all image keys available
 *
 *  @return NSArray of image keys
 */
+ (NSArray *)allImageKeys;

/**
 *  Return all color keys available
 *
 *  @return NSArray of color keys
 */
+ (NSArray *)allColorKeys;

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE

/**
 *  Return an image (iOS only)
 *
 *  @param key key for an image that has been been setup in your admin panel
 *
 *  @return UIImage image
 */
+ (UIImage *)imageWithKey:(NSString *)key;

/**
 *  Return a color (iOS only)
 *
 *  @param key key for a color that has been been setup in your admin panel
 *
 *  @return UIColor color
 */
+ (UIColor *)colorWithKey:(NSString *)key;

#elif TARGET_OS_MAC

/**
 *  Return an image (Mac/Cocoa only)
 *
 *  @param key key for an image that has been been setup in your admin panel
 *
 *  @return NSImage image
 */
+ (NSImage *)imageWithKey:(NSString *)key;

/**
 *  Return a color (Mac/Cocoa only)
 *
 *  @param key key for a color that has been been setup in your admin panel
 *
 *  @return NSColor color
 */
+ (NSColor *)colorWithKey:(NSString *)key;

#endif

/**
 *  Returns a color key
 *
 *  @note Returns code like #FF0000 but without the leading hash (so, FF0000)
 *
 *  @param key key for a color that has been been setup in your admin panel
 *
 *  @return NSString color code
 */
+ (NSString *)colorCodeWithKey:(NSString *)key;

/**
 *  Returns a color alpha value
 *
 *  @param key key key for a color that has been been setup in your admin panel
 *
 *  @return float 0.0f - 1.0f for color's alpha value
 */
+ (CGFloat)alphaForColorWithKey:(NSString *)key;

/**
 *  Return an image data
 *
 *  @param key key for an image that has been been setup in your admin panel
 *
 *  @return NSData image data
 */
+ (NSData *)imageDataWithKey:(NSString *)key;


@end
