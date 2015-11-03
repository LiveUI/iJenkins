//
//  SKSpriteNode+LUIImages.h
//
//  Created by Ondrej Rafaj on 03/06/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@interface SKSpriteNode (LUIImages)

/**
 *  Return sprite node with texture/image from LiveUI
 *
 *  @param name name/key of the image
 *
 *  @return SKSpriteNode node
 */
+ (SKSpriteNode *)spriteNodeWithLUIImageNamed:(NSString *)name;

/**
 *  Register node's texture to be reloaded once a new image is fetched
 *
 *  @param key localization key setup in the admin panel
 */
- (void)registerNodeWithImageKey:(NSString *)key;


@end
