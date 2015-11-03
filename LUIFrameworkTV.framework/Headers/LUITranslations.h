//
//  LUITranslations.h
//
//  Created by Ondrej Rafaj on 20/04/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LUIEnums.h"
#import "LUIBasicData.h"


/**
 *  To override NSLocalizedString(key, comment), import the NSLocalizedStringOverride.h in your files instead of LUIFramework.h:
 *
 *  #import <LUIFramework/NSLocalizedStringOverride.h>
 *
 *  instead of
 *
 *  #import <LUIFramework/LUIFramework.h>
 */

/**
 *  Notification that will be fired when translation is updated
 *
 *  @note You can use this for example to reload the interface
 */
extern NSString *const LUITranslationDidUpdateContentNotification;

/**
 *  Returns localized string
 *
 *  @param key     key for the string that has been been setup in your admin panel
 *  @param comment description for the key, this is not processed in any way, can be nil
 *
 *  @return NSString localized string
 */
#define LUILocalizedString(key, comment)                    [[LUITranslations sharedInstance] get:key table:nil]

/**
 *  Returns localized string
 *
 *  @param key           key for the string that has been been setup in your admin panel
 *  @param defaultString default string that will be used in case there is no translation available
 *
 *  @return NSString localized string
 */
#define LUITranslateWithDefault(key, defaultString)         [[LUITranslations sharedInstance] get:key withDefaultString:defaultString table:nil]

/**
 *  Returns localized string
 *
 *  @param key key for the string that has been been setup in your admin panel
 *
 *  @return NSString localized string
 */
#define LUITranslate(key)                                   LUILocalizedString(key, nil)


@interface LUITranslations : LUIBasicData

/**
 *  You can manually set language code (en-US, de, cz)
 *
 *  @note Make sure the language code is present in -availableLanguages
 */
@property (nonatomic, strong) NSString *currentLanguageCode;

/**
 *  Shows is remote data has been already loaded
 */
@property (nonatomic, readonly) LUIDataSource currentDataSource;

/**
 *  Translation version, default is LUIBuildLive
 *  
 *  @note Use NSInteger for specific version
 */
@property (nonatomic) LUIBuild version;

/**
 *  Default is NO, if set, any translation coming through LiveUI SDK will result in a series of underscores (_)
 *  
 *  @note This is very usefult for debugging forgotten translations
 *  @note !!! This won't work without the main debug mode being enabled !!!
 */
@property (nonatomic) BOOL replaceStringsForUnderscores;

/**
 *  Instance of LUITranslations
 *
 *  @note Use instead any -init methods, if you use -init, your app will crash
 *
 *  @return LUITranslations instance of this object
 */
+ (instancetype)sharedInstance;

/**
 *  Return all translation keys available
 *
 *  @return NSArray of language keys
 */
+ (NSArray *)allKeys;

/**
 *  Returns all available language codes in an array
 *
 *  @return NSArray of available languages
 */
+ (NSArray *)availableLanguages;

/**
 *  Getting translation codes
 *
 *  @note You can also use macros: LUILocalizedString(key, comment), LUITranslate(key) or LUITranslateWithDefault(key, defaultString)
 *
 *  @param key           key setup from admin panel
 *  @param defaultString default string that should be used in case translation is missing
 *  @param tableName     table/section (not being used at the moment)
 *
 *  @return NSString translation
 */
- (NSString *)get:(NSString *)key withDefaultString:(NSString *)defaultString table:(NSString *)tableName NS_FORMAT_ARGUMENT(1);
- (NSString *)get:(NSString *)key table:(NSString *)tableName NS_FORMAT_ARGUMENT(1);

//

/**
 *  Returns locale for currently selected language
 *
 *  @note Use this in NSDateFormatters, etc, to allow internationalization of your app
 *
 *  @return NSLocale current locale
 */
+ (NSLocale *)currentLocale;

/**
 *  Reloads translation data from the LiveUI servers
 *
 *  @note Using this method often will increase your API consumption significantly
 */
+ (void)reloadData;


@end
