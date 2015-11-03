//
//  UITextView+LUITranslations.h
//
//  Created by Ondrej Rafaj on 05/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITextView (LUITranslations)

/**
 *  Register text view to be reloaded once the localization is updated
 *
 *  @param key localization key setup in the admin panel
 */
- (void)registerWithTranslationKey:(NSString *)key;


@end
