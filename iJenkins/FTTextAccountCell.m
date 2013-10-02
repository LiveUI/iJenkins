//
//  FTTextAccountCell.m
//  iJenkins
//
//  Created by Ondrej Rafaj on 31/08/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "FTTextAccountCell.h"


@interface FTTextAccountCell ()

@end


@implementation FTTextAccountCell


#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark Create elements

- (void)createTextField {
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(130, 6, 176, (self.height - 12))];
    [_textField setDelegate:self];
    [_textField setTextAlignment:NSTextAlignmentRight];
    [_textField setFont:[UIFont systemFontOfSize:14]];
    [_textField setBackgroundColor:[UIColor clearColor]];
    [_textField setOrigin:CGPointMake((self.width - 14 - _textField.width), 6)];
    [_textField setAutoresizingWidthAndHeight];
    [_textField setReturnKeyType:UIReturnKeyDone];
    [self addSubview:_textField];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createTextField];
}

#pragma mark Settings

- (void)setCellData:(NSDictionary *)cellData {
    [super setCellData:cellData];
    [_textField setPlaceholder:[cellData objectForKey:@"placeholder"]];
    
    NSString *type = [cellData objectForKey:@"type"];
    if ([type isEqualToString:@"text"]) {
        [_textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    }
    else if ([type isEqualToString:@"url"]) {
        [_textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_textField setKeyboardType:UIKeyboardTypeURL];
    }
    else if ([type isEqualToString:@"password"]) {
        [_textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [_textField setSecureTextEntry:YES];
    }
    else if ([type isEqualToString:@"int"]) {
        [_textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_textField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    if (![type isEqualToString:@"int"]) {
        [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    }
}

- (void)setAccount:(FTAccount *)account {
    [super setAccount:account];
    
    NSString *variable = [self.cellData objectForKey:@"variable"];
    if ([variable isEqualToString:@"name"]) {
        [_textField setText:account.name];
    }
    else if ([variable isEqualToString:@"host"]) {
        [_textField setText:account.host];
    }
    else if ([variable isEqualToString:@"port"]) {
        [_textField setText:(account.port ? [NSString stringWithFormat:@"%d", account.port] : @"")];
    }
    else if ([variable isEqualToString:@"username"]) {
        [_textField setText:account.username];
    }
    else if ([variable isEqualToString:@"passwordOrToken"]) {
        [_textField setText:account.passwordOrToken];
    }
    else if ([variable isEqualToString:@"pathSuffix"]) {
        [_textField setText:account.pathSuffix];
    }
    else if ([variable isEqualToString:@"loadMaxItems"]) {
        [_textField setText:[NSString stringWithFormat:@"%d", account.loadMaxItems]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        if (!_textField.isFirstResponder) {
            [_textField becomeFirstResponder];
            if ([self.delegate respondsToSelector:@selector(basicAccountCell:didStartEditing:)]) {
                [self.delegate basicAccountCell:self didStartEditing:YES];
            }
        }
        else {
            [_textField resignFirstResponder];
            if ([self.delegate respondsToSelector:@selector(basicAccountCell:didStartEditing:)]) {
                [self.delegate basicAccountCell:self didStartEditing:NO];
            }
        }
    }
}

#pragma mark Textfield delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(basicAccountCell:didStartEditing:)]) {
        [self.delegate basicAccountCell:self didStartEditing:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSString *variable = [self.cellData objectForKey:@"variable"];
    if ([variable isEqualToString:@"name"]) {
        [self.account setName:textField.text];
    }
    else if ([variable isEqualToString:@"host"]) {
        [self.account setHost:textField.text];
    }
    else if ([variable isEqualToString:@"port"]) {
        [self.account setPort:textField.text.integerValue];
    }
    else if ([variable isEqualToString:@"username"]) {
        [self.account setUsername:textField.text];
    }
    else if ([variable isEqualToString:@"passwordOrToken"]) {
        [self.account setPasswordOrToken:textField.text];
    }
    else if ([variable isEqualToString:@"pathSuffix"]) {
        [self.account setPathSuffix:textField.text];
    }
    else if ([variable isEqualToString:@"loadMaxItems"]) {
        [self.account setLoadMaxItems:textField.text.integerValue];
    }
    [super cellDidChangeValue];
    return YES;
}


@end
