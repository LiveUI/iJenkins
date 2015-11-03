//
//  UIBarItem+LUITranslations.h
//
//  Created by Ondrej Rafaj on 05/02/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIBarItem (LUITranslations)

/**
 *  Register bar item to be reloaded once the localization is updated
 *
 *  @param key localization key setup in the admin panel
 */
- (void)registerTitleWithTranslationKey:(NSString *)key;


@end
