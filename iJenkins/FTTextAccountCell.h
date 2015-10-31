//
//  FTTextAccountCell.h
//  iJenkins
//
//  Created by Ondrej Rafaj on 31/08/2013.
//  Copyright (c) 2013 Ridiculous Innovations. All rights reserved.
//

#import "FTBasicAccountCell.h"


@interface FTTextAccountCell : FTBasicAccountCell <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;


@end
