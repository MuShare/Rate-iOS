//
//  LoginViewController.m
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/2/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    BOOL showPassword;
}

- (void)viewDidLoad {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    showPassword = NO;
}

- (BOOL)hidesBottomBarWhenPushed {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return YES;
}

- (IBAction)showPassword:(id)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    showPassword = !showPassword;
    [_showPasswordButton setImage:[UIImage imageNamed:showPassword? @"login_password_show": @"login_password_hide"]
                         forState:UIControlStateNormal];
}
@end
