//
//  UIImageView+LUIImages.h
//
//  Created by Ondrej Rafaj on 08/06/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImageView (LUIImages)

/**
 *  Register image view to be reloaded once a new image is fetched
 *
 *  @param key localization key setup in the admin panel
 */
- (void)registerWithImageKey:(NSString *)key;


@end
