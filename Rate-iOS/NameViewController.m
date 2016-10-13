//
//  NameViewController.m
//  Rate-iOS
//
//  Created by lidaye on 8/7/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "NameViewController.h"
#import "InternetTool.h"
#import "UserTool.h"
#import "AlertTool.h"

@interface NameViewController ()

@end

@implementation NameViewController {
    AFHTTPSessionManager *manager;
    UserTool *user;
}

- (void)viewDidLoad {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    manager = [InternetTool getSessionManager];
    user = [[UserTool alloc] init];
}

#pragma mark - Action
- (IBAction)saveName:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if ([_nameTextField.text isEqualToString:@""]) {
        
        return;
    }
    [manager POST:[InternetTool createUrl:@"api/user/change_uname"]
       parameters:@{
                    @"uname": _nameTextField.text
                    }
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
              if ([response statusOK]) {
                  user.name = _nameTextField.text;
                  [self.navigationController popViewControllerAnimated:YES];
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              InternetResponse *response = [[InternetResponse alloc] initWithError:error];
              switch ([response errorCode]) {
                  case ErrorCodeNotConnectedToInternet:
                      [AlertTool showNotConnectInternet:self];
                      break;
                  default:

                      break;
              }
          }];
}
@end
