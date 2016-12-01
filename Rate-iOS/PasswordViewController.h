//
//  PasswordViewController.h
//  Rate-iOS
//
//  Created by lidaye on 8/7/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *validateCodeImageView;
@property (weak, nonatomic) IBOutlet UITextField *validationCodeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImageView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *showPasswordButton;

- (IBAction)showPassword:(id)sender;
- (IBAction)resendValidationCode:(id)sender;

@end
