//
//  FTView.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 30/08/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FTView : UIView

- (BOOL)isRetina;
- (BOOL)isBigPhone;
- (CGFloat)screenHeight;
- (BOOL)isOS7;

- (void)setupView;
- (void)createAllElements;


@end
