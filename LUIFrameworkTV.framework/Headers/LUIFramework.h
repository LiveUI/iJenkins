//
//  LUIFramework.h
//
//  Created by Ondrej Rafaj on 17/04/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

#elif TARGET_OS_MAC

#import <Cocoa/Cocoa.h>

#endif


//! Project version number for LUIFramework.
FOUNDATION_EXPORT double LUIFrameworkVersionNumber;

//! Project version string for LUIFramework.
FOUNDATION_EXPORT const unsigned char LUIFrameworkVersionString[];


#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE

// iOS only helper categories
#import <LUIFrameworkTV/UILabel+LUITranslations.h>
#import <LUIFrameworkTV/UIBarItem+LUITranslations.h>
#import <LUIFrameworkTV/UISearchBar+LUITranslations.h>
#import <LUIFrameworkTV/UITextField+LUITranslations.h>
#import <LUIFrameworkTV/UIViewController+LUITranslations.h>
#import <LUIFrameworkTV/UIButton+LUITranslations.h>
#import <LUIFrameworkTV/UITextView+LUITranslations.h>
#import <LUIFrameworkTV/UITableView+LUITranslations.h>

#import <LUIFrameworkTV/UIImageView+LUIImages.h>
#import <LUIFrameworkTV/UIButton+LUIImages.h>

// iOS specific interfaces
#import <LUIFrameworkTV/LUILanguageSelectorViewController.h>

#elif TARGET_OS_MAC

// Mac only helper categories
#import <LUIFrameworkTV/NSViewController+LUITranslations.h>
#import <LUIFrameworkTV/NSWindow+LUITranslations.h>
#import <LUIFrameworkTV/NSButton+LUITranslations.h>
#import <LUIFrameworkTV/NSTextField+LUITranslations.h>

#endif

// Common helper categories
#import <LUIFrameworkTV/NSObject+LUITranslations.h>
#import <LUIFrameworkTV/NSObject+LUIVisuals.h>

#import <LUIFrameworkTV/LUIEnums.h>
#import <LUIFrameworkTV/LUILanguage.h>
#import <LUIFrameworkTV/LUIURLs.h>

#import <LUIFrameworkTV/LUIMain.h>
#import <LUIFrameworkTV/LUITranslations.h>
#import <LUIFrameworkTV/LUIVisuals.h>

#import <LUIFrameworkTV/LUIDebugger.h>

