//
//  UITableView+LUITranslations.h
//
//  Created by Ondrej Rafaj on 26/05/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITableView (LUITranslations)

/**
 *  Register table view to be reloaded once the localization is updated
 *
 *  @param key localization key setup in the admin panel
 */
- (void)registerForReloadDataOnTranslationChange;


@end
