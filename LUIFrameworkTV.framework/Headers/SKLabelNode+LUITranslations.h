//
//  SKLabelNode+LUITranslations.h
//
//  Created by Ondrej Rafaj on 08/06/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@interface SKLabelNode (LUITranslations)

/**
 *  Register label node to be reloaded once the localization is updated
 *
 *  @param key localization key setup in the admin panel
 */
- (void)registerTextWithTranslationKey:(NSString *)key;


@end
