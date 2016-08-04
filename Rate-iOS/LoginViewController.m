//
//  LoginViewController.m
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/2/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "LoginViewController.h"
#import "CommonTool.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
}

- (BOOL)hidesBottomBarWhenPushed {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return YES;
}

#pragma -mark UITextViewDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
}


#pragma -mark Action
- (IBAction)showPassword:(id)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    _passwordTextField.secureTextEntry = !_passwordTextField.secureTextEntry;
    [_showPasswordButton setImage:[UIImage imageNamed:_passwordTextField.secureTextEntry? @"login_password_hide": @"login_password_show"]
                         forState:UIControlStateNormal];
}

- (IBAction)loginSubmit:(id)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    _emailImageView.highlighted = ![CommonTool isAvailableEmail:_emailTextField.text];
    _passwordImageView.highlighted = [_passwordTextField.text isEqualToString:@""];
    if(_emailImageView.highlighted || _passwordImageView.highlighted) {
        return;
    }
}

- (IBAction)finishEdit:(id)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [sender resignFirstResponder];
}
@end
