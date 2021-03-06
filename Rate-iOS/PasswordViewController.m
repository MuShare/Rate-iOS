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
    _sendButton.enabled = NO;
    [manager POST:[InternetTool createUrl:@"api/user/verification_code"]
       parameters:@{@"email": _emailTextField.text}
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
              if ([response statusOK]) {
                  _emailTextField.enabled = NO;
                  _sendButton.enabled = YES;
                  [AlertTool showAlertWithTitle:NSLocalizedString(@"tip_name", @"Tip")
                                     andContent:NSLocalizedString(@"send_validation_code_success", nil)
                               inViewController:self];
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              InternetResponse *response = [[InternetResponse alloc] initWithError:error];
              _sendButton.enabled = YES;
              switch ([response errorCode]) {
                  case  ErrorCodeMailNotExist:
                      [AlertTool showAlertWithTitle:NSLocalizedString(@"tip_name", @"tip")
                                         andContent:NSLocalizedString(@"mail_not_exsit", nil)
                                   inViewController:self];
                      break;
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
    if (_verificationCodeImageView.highlighted || _passwordImageView.highlighted) {
        return;
    }
    [_loadingActivityIndicatorView startAnimating];
    _submitButton.enabled = NO;
    [manager POST:[InternetTool createUrl:@"api/user/change_password"]
       parameters:@{
                    @"email": _emailTextField.text,
                    @"password": _passwordTextField.text,
                    @"vertificationCode": _verificationCodeTextField.text
                    }
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              InternetResponse *repsonse = [[InternetResponse alloc] initWithResponseObject:responseObject];
              if ([repsonse statusOK]) {
                  //Modified password scuessfully.
                  _modifySuccessView.hidden = NO;
                  [_submitButton removeFromSuperview];
                  [_loadingActivityIndicatorView stopAnimating];
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              InternetResponse *response = [[InternetResponse alloc] initWithError:error];
              _submitButton.enabled = YES;
              [_loadingActivityIndicatorView stopAnimating];
              switch ([response errorCode]) {
                  case ErrorCodeMailNotExist:
                      [AlertTool showAlertWithTitle:NSLocalizedString(@"tip_name", @"tip")
                                         andContent:NSLocalizedString(@"mail_not_exsit", nil)
                                   inViewController:self];
                      break;
                  case ErrorCodeInvalidVerification:
                      [AlertTool showAlertWithTitle:NSLocalizedString(@"tip_name", @"tip")
                                         andContent:NSLocalizedString(@"verification_code_error", nil)
                                   inViewController:self];
                      break;
                  case ErrorCodeVerificationExpiration:
                      [AlertTool showAlertWithTitle:NSLocalizedString(@"tip_name", @"tip")
                                         andContent:NSLocalizedString(@"verification_expiration", nil)
                                   inViewController:self];
                      break;
                  default:
                      break;
              }
          }];
}
@end
