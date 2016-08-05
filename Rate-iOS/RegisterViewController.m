//
//  RegisterViewController.m
//  Rate-iOS
//
//  Created by lidaye on 8/5/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "RegisterViewController.h"
#import "CommonTool.h"
#import "InternetTool.h"
#import "AlertTool.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController {
    AFHTTPSessionManager *manager;
}

- (void)viewDidLoad {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    manager = [InternetTool getSessionManager];
}

- (BOOL)hidesBottomBarWhenPushed {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return YES;
}

#pragma mark - Action
- (IBAction)registerSubmit:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if(!_registerSuccessView.hidden) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    _emailImageView.highlighted = ![CommonTool isAvailableEmail:_emailTextField.text];
    _telephoneImageView.highlighted = [_telephoneTextField.text isEqualToString:@""];
    _usernameImageView.highlighted = [_usernameTextField.text isEqualToString:@""];
    _passwordImageView.highlighted = [_passwordTextField.text isEqualToString:@""];
    if (_emailImageView.highlighted || _telephoneImageView.highlighted || _usernameImageView.highlighted || _passwordImageView.highlighted) {
        return;
    }
    _loadingActivityIndicatorView.hidden = NO;
    [_loadingActivityIndicatorView startAnimating];
    _registerSubmitButton.enabled = NO;
    [_registerSubmitButton setTitle:@"Loading..." forState:UIControlStateNormal];
    [manager POST:[InternetTool createUrl:@"api/user/register"]
       parameters:@{
                    @"email": _emailTextField.text,
                    @"password": _passwordTextField.text,
                    @"telephone": _telephoneTextField.text,
                    @"uname": _usernameTextField.text
                    }
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              _loadingActivityIndicatorView.hidden = YES;
              _registerSubmitButton.enabled = YES;
              [_registerSubmitButton setTitle:@"Sign in" forState:UIControlStateNormal];
              InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
              if ([response statusOK]) {
                  _registerSuccessView.hidden = NO;
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              if (DEBUG) {
                  NSLog(@"Server error: %@", error.localizedDescription);
              }
              _loadingActivityIndicatorView.hidden = YES;
              _registerSubmitButton.enabled = YES;
              [_registerSubmitButton setTitle:@"Submit" forState:UIControlStateNormal];
              InternetResponse *response = [[InternetResponse alloc] initWithError:error];
              switch ([response errorCode]) {
                  case ErrorCodeEmailExsit:
                      _emailImageView.highlighted = YES;
                      _telephoneImageView.highlighted = NO;
                      [AlertTool showAlertWithTitle:@"Tip"
                                         andContent:@"Your email has been signed up."
                                   inViewController:self];
                      break;
                  case ErrorCodeTelephoneExsit:
                      _telephoneImageView.highlighted = YES;
                      _emailImageView.highlighted = NO;
                      [AlertTool showAlertWithTitle:@"Tip"
                                         andContent:@"Your telephone has been signed up."
                                   inViewController:self];
                      break;
                  default:
                      break;
              }
          }];
}

- (IBAction)finishEdit:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [sender resignFirstResponder];
}

- (IBAction)showPassword:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    _passwordTextField.secureTextEntry = !_passwordTextField.secureTextEntry;
    [_showPasswordButton setImage:[UIImage imageNamed:_passwordTextField.secureTextEntry? @"login_password_hide": @"login_password_show"]
                         forState:UIControlStateNormal];
}
@end

