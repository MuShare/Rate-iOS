//
//  PasswordViewController.m
//  Rate-iOS
//
//  Created by lidaye on 8/7/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "PasswordViewController.h"
#import "UserTool.h"
#import "InternetTool.h"
#import "AlertTool.h"
#import "CommonTool.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController {
    UserTool *user;
    AFHTTPSessionManager *manager;
}

- (void)viewDidLoad {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    
    manager = [InternetTool getSessionManager];
    user = [[UserTool alloc] init];
    
    if (user.token != nil) {
        _emailTextField.text = user.email;
        _emailTextField.enabled = NO;
    }

    _sendButton.layer.borderColor = [UIColor colorWithRed:14.0 / 255 green:189.0 / 255 blue:159.0 / 255 alpha:1.0].CGColor;
}

#pragma mark - Action
- (IBAction)showPassword:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    _passwordTextField.secureTextEntry = !_passwordTextField.secureTextEntry;
    [_showPasswordButton setImage:[UIImage imageNamed:_passwordTextField.secureTextEntry? @"login_password_hide": @"login_password_show"]
                         forState:UIControlStateNormal];
}

- (void)sendVerificationCode:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    _emailImageView.highlighted = ![CommonTool isAvailableEmail:_emailTextField.text];
    if (_emailImageView.highlighted) {
        return;
    }
    [manager POST:[InternetTool createUrl:@"api/user/verification_code"]
       parameters:@{@"email": _emailTextField.text}
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
              if ([response statusOK]) {
                  _emailTextField.enabled = NO;
                  [AlertTool showAlertWithTitle:NSLocalizedString(@"tip_name", @"Tip")
                                     andContent:NSLocalizedString(@"send_validation_code_success", @"Verification code has sent to your email.")
                               inViewController:self];
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              InternetResponse *response = [[InternetResponse alloc] initWithError:error];
              switch ([response errorCode]) {
                  default:
                      break;
              }
          }];
}

- (IBAction)submitNewPassword:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    _verificationCodeImageView.highlighted = [_verificationCodeTextField.text isEqualToString:@""];
    _passwordImageView.highlighted = [_passwordTextField.text isEqualToString:@""];
    if (_emailImageView.highlighted && _passwordImageView.highlighted) {
        return;
    }
}
@end
