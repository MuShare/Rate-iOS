//
//  LoginViewController.h
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/2/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *emailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImageView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *showPasswordButton;

- (IBAction)showPassword:(id)sender;
- (IBAction)loginSubmit:(id)sender;
- (IBAction)finishEdit:(id)sender;

@end
