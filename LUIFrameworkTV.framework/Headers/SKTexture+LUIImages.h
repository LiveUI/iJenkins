//
//  SKTexture+LUIImages.h
//
//  Created by Ondrej Rafaj on 03/06/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@interface SKTexture (LUIImages)

/**
 *  Return texture with image from LiveUI
 *
 *  @param name name/key of the image
 *
 *  @return SKTexture texture
 */
+ (SKTexture *)textureWithLUIImageNamed:(NSString *)name;


@end
