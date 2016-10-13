//
//  FeedbackViewController.m
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "FeedbackViewController.h"
#import "InternetTool.h"
#import "AlertTool.h"
@interface FeedbackViewController ()

@end

@implementation FeedbackViewController {
    AFHTTPSessionManager *manager;
}

- (void)viewDidLoad {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    manager = [InternetTool getSessionManager];
    [self setCloseKeyboardAccessoryForSender:_contentTextView];
    [self setCloseKeyboardAccessoryForSender:_contactTextField];
}

#pragma mark - Delegate: UITextFeildDelegate
//开始编辑输入框的时候，软键盘出现，执行此事件
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    //键盘高度260
    float keyboardHeight = 260.0;
    CGRect frame = textField.frame;
    int offset = frame.origin.y + textField.frame.size.height - (self.view.frame.size.height - keyboardHeight);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0) {
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - Action
- (IBAction)submitFeedback:(id)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if([_contactTextField.text isEqualToString:@""] || [_contentTextView.text isEqualToString:@""]) {
        [AlertTool showAlertWithTitle:NSLocalizedString(@"warning_name", @"Warning")
                           andContent:NSLocalizedString(@"feedback_not_validate", @"Write content and contact info!")
                     inViewController:self];
        return;
    }
    [manager POST:[InternetTool createUrl:@"api/user/add_feedback"]
       parameters:@{
                    @"type": [NSNumber numberWithLong:_typeSegmentedControl.selectedSegmentIndex],
                    @"content": _contentTextView.text,
                    @"contact": _contactTextField.text
                    }
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
              if ([response statusOK]) {
                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"tip_name", @"Tip")
                                                                                           message:NSLocalizedString(@"feedback_not_validate", @"Write content and contact info!")
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok_name", @"OK")
                                                                         style:UIAlertActionStyleCancel
                                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                                           [self.navigationController popViewControllerAnimated:YES];
                                                                       }];
                
                  [alertController addAction:cancelAction];
                  [self presentViewController:alertController animated:YES completion:nil];
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

#pragma mark - Service
//Create done button for keyboard
- (void)setCloseKeyboardAccessoryForSender:(id)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.window.frame.size.width, 35)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem* spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                     target:self
                                                                                     action:nil];
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self
                                                                                    action:@selector(editFinish)];
    doneButtonItem.tintColor = [UIColor colorWithRed:38/255.0 green:186/255.0 blue:152/255.0 alpha:1.0];
    NSArray * buttonsArray = [NSArray arrayWithObjects:spaceButtonItem, doneButtonItem, nil];
    [topView setItems:buttonsArray];
    [sender setInputAccessoryView:topView];
}

- (void)editFinish {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    for(id input in self.view.subviews){
        if([input isKindOfClass:[UITextField class]]){
            UITextField *this = input;
            if([this isFirstResponder]) {
                [this resignFirstResponder];
            }
        } else if ([input isKindOfClass:[UITextView class]]) {
            UITextView *this = input;
            if ([this isFirstResponder]) {
                [this resignFirstResponder];
            }
        }
    }
}

@end
