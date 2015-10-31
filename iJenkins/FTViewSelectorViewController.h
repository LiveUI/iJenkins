//
//  FTViewSelectorViewController.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 14/09/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTViewController.h"


@class FTViewSelectorViewController;

@protocol FTViewSelectorViewControllerDelegate <NSObject>

- (void)viewSelectorController:(FTViewSelectorViewController *)controller didSelect:(FTAPIServerViewDataObject *)view;

@end


@interface FTViewSelectorViewController : FTViewController

@property (nonatomic, strong) NSArray *views;
@property (nonatomic, strong) FTAPIServerViewDataObject *selectedView;

@property (nonatomic, weak) id <FTViewSelectorViewControllerDelegate> delegate;


@end
