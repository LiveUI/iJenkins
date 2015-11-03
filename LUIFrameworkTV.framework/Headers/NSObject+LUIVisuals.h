//
//  NSObject+LUIVisuals.h
//
//  Created by Ondrej Rafaj on 20/06/2015.
//  Copyright (c) 2015 Ridiculous Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (LUIVisuals)

/**
 *  Register any object to be reloaded once the vials are updated
 *
 *  @note Element needs to have a method -reloadData implemented in order to make this work
 */
- (void)registerVisualsForReloadData;


@end
