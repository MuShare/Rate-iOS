//
//  LoginViewController.m
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/2/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "LoginViewController.h"
#import "CommonTool.h"
#import "InternetTool.h"
#import "UserTool.h"
#import "DaoManager.h"
#import "AlertTool.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    AFHTTPSessionManager *manager;
    UserTool *user;
    DaoManager *dao;
    AppDelegate *delegate;
}

- (void)viewDidLoad {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    manager = [InternetTool getSessionManager];
    user = [[UserTool alloc] init];
    dao = [[DaoManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (delegate.regInfo != nil) {
        _emailTextField.text = [delegate.regInfo valueForKey:@"username"];
        _passwordTextField.text = [delegate.regInfo valueForKey:@"password"];
        delegate.regInfo = nil;
    }
}

- (BOOL)hidesBottomBarWhenPushed {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return YES;
}

#pragma - mark UITextViewDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
}


#pragma - mark Action
- (IBAction)showPassword:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    _passwordTextField.secureTextEntry = !_passwordTextField.secureTextEntry;
    [_showPasswordButton setImage:[UIImage imageNamed:_passwordTextField.secureTextEntry? @"login_password_hide": @"login_password_show"]
                         forState:UIControlStateNormal];
}

- (IBAction)loginSubmit:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    _emailImageView.highlighted = ![CommonTool isAvailableEmail:_emailTextField.text];
    _passwordImageView.highlighted = [_passwordTextField.text isEqualToString:@""];
    if (_emailImageView.highlighted || _passwordImageView.highlighted) {
        return;
    }
    [_loadingActivityIndicatorView startAnimating];
    _loginSubmitButton.enabled = NO;
    UIDevice *currentDevice = [UIDevice currentDevice];
    
    [manager POST:[InternetTool createUrl:@"api/user/login/email"]
       parameters:@{
                    @"email": _emailTextField.text,
                    @"password": _passwordTextField.text,
                    @"os": @"iOS",
                    @"version": [NSString stringWithFormat:@"%@", currentDevice.systemVersion],
                    @"identifier": [currentDevice.identifierForVendor UUIDString],
                    @"device_token": user.deviceToken,
                    @"lan": user.lan
                    }
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              _loadingActivityIndicatorView.hidden = YES;
              _loginSubmitButton.enabled = YES;
              InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
              if ([response statusOK]) {
                  NSObject *result = [response getResponseResult];
                  user.email = _emailTextField.text;
                  user.name = [[result valueForKey:@"user"] valueForKey:@"name"];
                  user.token = [result valueForKey:@"token"];
                  
                  /**
                  user.notification = [result valueForKey:@"notification"];
                  //Set user's favorite currencies
                  NSArray *favorites = [result valueForKey:@"favorite"];
                  for(NSString *cid in favorites) {
                      Currency *currency = [dao.currencyDao getByCid:cid];
                      currency.favorite = [NSNumber numberWithBool:YES];
                  }
                   **/
                  [dao saveContext];
                  manager = [InternetTool getSessionManager];
                  [self.navigationController popViewControllerAnimated:YES];
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              if (DEBUG) {
                  NSLog(@"Server error: %@", error.localizedDescription);
              }
              _loadingActivityIndicatorView.hidden = YES;
              _loginSubmitButton.enabled = YES;
              InternetResponse *response = [[InternetResponse alloc] initWithError:error];
              switch ([response errorCode]) {
                  case ErrorCodeNotConnectedToInternet:
                      [AlertTool showNotConnectInternet:self];
                      break;
                  case ErrorCodeAccountNotFound:
                      _emailImageView.highlighted = YES;
                      _passwordImageView.highlighted = NO;
                      [AlertTool showAlertWithTitle:NSLocalizedString(@"tip_name", @"Tip")
                                         andContent:NSLocalizedString(@"sign_in_error_account_not_exsit", @"This account is not exsit!")
                                   inViewController:self];
                      break;
                  case ErrorCodePasswordWrong:
                      _passwordImageView.highlighted = YES;
                      _emailImageView.highlighted = NO;
                      [AlertTool showAlertWithTitle:NSLocalizedString(@"tip_name", @"Tip")
                                         andContent:NSLocalizedString(@"sign_in_error_password_wrong", @"Password is wrong!")
                                   inViewController:self];
                      break;

                  default:
                      break;
              }
              [_loadingActivityIndicatorView stopAnimating];
          }];
}

- (IBAction)finishEdit:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [sender resignFirstResponder];
}
@end
