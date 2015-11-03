//
//  UIButton+LUITranslations.h
//
//  Created by Ondrej Rafaj on 05/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (LUITranslations)

/**
 *  Register button's title (on UIControlStateNormal) to be reloaded once the localization is updated
 *
 *  @param key localization key setup in the admin panel
 */
- (void)registerNormalStateTitleWithTranslationKey:(NSString *)key;


@end
