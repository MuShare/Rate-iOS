//
//  AddSubscribeTableViewController.m
//  Rate-iOS
//
//  Created by lidaye on 8/1/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "AddSubscribeTableViewController.h"
#import "InternetTool.h"
#import "UserTool.h"
#import "DaoManager.h"
#import "AlertTool.h"

@interface AddSubscribeTableViewController ()

@end

@implementation AddSubscribeTableViewController {
    AFHTTPSessionManager *manager;
    UserTool *user;
    DaoManager *dao;
    float currentRate;
}

- (void)viewDidLoad {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    manager = [InternetTool getSessionManager];
    user = [[UserTool alloc] init];
    dao = [[DaoManager alloc] init];
    
    [_thresholdTextField addTarget:self action:@selector(thresholdTextFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
    [self setCloseKeyboardAccessoryForSender: _thresholdTextField];
}

- (void)viewWillAppear:(BOOL)animated {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewWillAppear:animated];
    if (_fromCurrency == _toCurrency && _fromCurrency != nil) {
        [AlertTool showAlertWithTitle:@"Warning"
                           andContent:@"Two currencies cannot be same!"
                     inViewController:self];
        return;
    }
    if (_fromCurrency != nil) {
        [_fromCurrencyButton setTitle:_fromCurrency.name forState:UIControlStateNormal];
    }
    if (_toCurrency != nil) {
        [_toCurrencyButton setTitle:_toCurrency.name forState:UIControlStateNormal];
    }
    
    //Load current rate from server.
    if(_fromCurrency != nil && _toCurrency != nil) {
        [manager GET:[InternetTool createUrl:@"api/rate/current"]
          parameters:@{
                       @"from": _fromCurrency.cid,
                       @"to": _toCurrency.cid
                       }
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
                 if([response statusOK]) {
                     currentRate = [[[response getResponseResult] objectForKey:@"rate"] floatValue];
                     _subscribeTipLabel.hidden = NO;
                     [self thresholdTextFieldDidChange:_thresholdTextField];
                 }
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 if(DEBUG) {
                     NSLog(@"Server error: %@", error.localizedDescription);
                 }
             }];
    }
}

#pragma mark - Table view Delegate
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    //Clear header view color
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 0.1;
}

#pragma mark - UITextViewDelegate


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if([segue.identifier isEqualToString:@"selectSubscribeFromSegue"]) {
        [segue.destinationViewController setValue:@YES forKey:@"selectable"];
        [segue.destinationViewController setValue:@"fromCurrency" forKey:@"currencyAttributeName"];
    } else if ([segue.identifier isEqualToString:@"selectSubscribeToSegue"]) {
        [segue.destinationViewController setValue:@YES forKey:@"selectable"];
        [segue.destinationViewController setValue:@"toCurrency" forKey:@"currencyAttributeName"];
    }
}

#pragma mark - Action
- (IBAction)saveSubscribe:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if ([_subscribeNameTextField.text isEqualToString:@""]) {
        return;
    }
    if ([_thresholdTextField.text isEqualToString:@""]) {
        
        return;
    }
    if (_fromCurrency == nil) {
        
        return;
    }
    if (_toCurrency == nil) {
        
        return;
    }
    NSLog(@"Validate success!");
    [manager POST:[InternetTool createUrl:@"api/user/subscribe"]
       parameters:@{
                    @"sname": _subscribeNameTextField.text,
                    @"from": _fromCurrency.cid,
                    @"to": _toCurrency.cid,
                    @"isEnable": [NSNumber numberWithBool:_enableSwitch.on],
                    @"isSendEmail": [NSNumber numberWithBool:_sendEmailSwitch.on],
                    @"isSendSms": [NSNumber numberWithBool:_sendEmailSwitch.on],
                    @"threshold": _thresholdTextField.text,
                    @"isAbove": [NSNumber numberWithInt:[_thresholdTextField.text floatValue] < currentRate]
                    }
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
              if([response statusOK]) {
                  [self.navigationController popViewControllerAnimated:YES];
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              if(DEBUG) {
                  NSLog(@"Server error: %@", error.localizedDescription);
              }
              InternetResponse *response = [[InternetResponse alloc] initWithError:error];
              switch ([response errorCode]) {
                  case ErrorCodeTokenError:
                      
                      break;
                      
                  default:
                      if (DEBUG) {
                          NSLog(@"Error code is %d", [response errorCode]);
                      }
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
    [_thresholdTextField resignFirstResponder];
}

- (void)thresholdTextFieldDidChange:(UITextField *)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if ([_thresholdTextField.text isEqualToString:@""]) {
        _subscribeTipLabel.text = [NSString stringWithFormat:@"Current rate is %.4f", currentRate];
        return;
    }
    float rate = [sender.text floatValue];
    if (rate > currentRate) {
        _subscribeTipLabel.text = @"Alert me above";
        _subscribeDownImageView.hidden = YES;
        _subscribeUpImageView.hidden = NO;
    } else {
        _subscribeTipLabel.text = @"Alert me blow";
        _subscribeUpImageView.hidden = YES;
        _subscribeDownImageView.hidden = NO;
    }
}

@end
