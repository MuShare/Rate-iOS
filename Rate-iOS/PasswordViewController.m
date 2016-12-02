//
//  PasswordViewController.m
//  Rate-iOS
//
//  Created by lidaye on 8/7/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    _sendButton.layer.borderColor = [UIColor colorWithRed:14.0 / 255 green:189.0 / 255 blue:159.0 / 255 alpha:1.0].CGColor;
}

#pragma mark - Action
- (IBAction)showPassword:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (IBAction)resendValidationCode:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}
@end
