//
//  RegisterViewController.h
//  Rate-iOS
//
//  Created by lidaye on 8/5/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *emailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *usernameImageView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImageView;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *showPasswordButton;
@property (weak, nonatomic) IBOutlet UIView *registerSuccessView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *registerSubmitButton;

- (IBAction)registerSubmit:(id)sender;
- (IBAction)finishEdit:(id)sender;
- (IBAction)showPassword:(id)sender;

@end
