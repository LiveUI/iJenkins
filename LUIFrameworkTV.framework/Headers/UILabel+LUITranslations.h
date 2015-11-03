//
//  UILabel+LUITranslations.h
//
//  Created by Ondrej Rafaj on 01/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UILabel (LUITranslations)

/**
 *  Register label to be reloaded once the localization is updated
 *
 *  @param key localization key setup in the admin panel
 */
- (void)registerWithTranslationKey:(NSString *)key;


@end
