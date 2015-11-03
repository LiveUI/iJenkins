//
//  NSObject+LUITranslations.h
//
//  Created by Ondrej Rafaj on 12/06/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (LUITranslations)

/**
 *  Register any object to be reloaded once the localization is updated
 *
 *  @note Element needs to have a method -reloadTranslatedValues implemented in order to make this work
 */
- (void)registerTranslationsForReloadData;


@end
