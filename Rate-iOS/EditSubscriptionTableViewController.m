//
//  EditSubscriptionTableViewController.m
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "EditSubscriptionTableViewController.h"
#import "InternetTool.h"
#import "CommonTool.h"
#import "AlertTool.h"

@interface EditSubscriptionTableViewController ()

@end

@implementation EditSubscriptionTableViewController {
    AFHTTPSessionManager *manager;
}

- (void)viewDidLoad {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    manager = [InternetTool getSessionManager];
    
    if(_subscribe == nil) {
        return;
    }
    _snameTextField.placeholder = _subscribe.sname;
    _fromImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", _subscribe.from.icon]];
    _toImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", _subscribe.to.icon]];
    _fromCodeLabel.text = _subscribe.from.code;
    _toCodeLabel.text = _subscribe.to.code;
    _currentRateLabel.text = [NSString stringWithFormat:@"%.3f", _subscribe.rate.floatValue];
    _thresholdTextField.placeholder = [NSString stringWithFormat:@"%.3f", _subscribe.threshold.floatValue];
    [_thresholdTextField addTarget:self action:@selector(thresholdTextFieldDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
    _enableSwitch.on = _subscribe.enable.boolValue;
    _sendEmailSwitch.on = _subscribe.sendEmail.boolValue;
    _sendSMSSwitch.on = _subscribe.sendSMS.boolValue;
    if(_subscribe.rate.floatValue > _subscribe.threshold.floatValue) {
        _trendImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

#pragma mark - Table view data source
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    //Clear header view color
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return 0.1;
}

#pragma mark - UITextFieldDelegate
- (void)thresholdTextFieldDidChange:(UITextField *)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    _subscribeTipLabel.hidden = [_thresholdTextField.text isEqualToString:@""];
    float rate = [sender.text floatValue];
    if (rate > _subscribe.rate.floatValue) {
        _subscribeTipLabel.text = @"Alert me above";
        [UIView animateWithDuration:0.5
                         animations:^{
                             _trendImageView.transform = CGAffineTransformMakeRotation(0);
                         }];
    } else {
        _subscribeTipLabel.text = @"Alert me blow";
        [UIView animateWithDuration:0.5
                         animations:^{
                             _trendImageView.transform = CGAffineTransformMakeRotation(M_PI);
                         }];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if ([segue.identifier isEqualToString:@"subscriptionRateSegue"]) {
        [segue.destinationViewController setValue:_subscribe.from forKey:@"fromCurrency"];
        [segue.destinationViewController setValue:_subscribe.to forKey:@"toCurrency"];
    }
}

#pragma mark - Action
- (IBAction)editSubscribe:(UIBarButtonItem *)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    _snameTextField.enabled = YES;
    _thresholdTextField.enabled = YES;
    _enableSwitch.enabled = YES;
    _sendEmailSwitch.enabled = YES;
    _sendSMSSwitch.enabled = YES;
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                    target:self
                                                                                    action:@selector(updateSubscribe)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
}

- (IBAction)deleteSubscribe:(id)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete subscription"
                                                                             message:@"Are you sure to delete this subscription?"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete it now"
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * _Nonnull action) {
        [AlertTool replaceBarButtonItemWithActivityIndicator:self];
        [manager DELETE:[InternetTool createUrl:@"api/user/subscribe"]
             parameters:@{
                          @"sid": _subscribe.sid
                          }
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
                    if([response statusOK]) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [alertController addAction:delete];
    [alertController addAction:cancel];
    alertController.popoverPresentationController.sourceView = _deleteSubscribeButton;
    alertController.popoverPresentationController.sourceRect = _deleteSubscribeButton.bounds;
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Service
- (void)updateSubscribe {
    if (DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    if(![_thresholdTextField.text isEqualToString:@""]) {
        if(![CommonTool isNumeric:_thresholdTextField.text]) {
            _trendImageView.highlighted = YES;
            return;
        } else {
            _trendImageView.highlighted = NO;
        }
    }

    [AlertTool replaceBarButtonItemWithActivityIndicator:self];
    
    [manager POST:[InternetTool createUrl:@"api/user/subscribe/update"]
       parameters:@{
                    @"sid": _subscribe.sid,
                    @"sname": [_snameTextField.text isEqualToString:@""]? _subscribe.sname: _snameTextField.text,
                    @"isEnable": [NSNumber numberWithBool:_enableSwitch.on],
                    @"isSendEmail": [NSNumber numberWithBool:_sendEmailSwitch.on],
                    @"isSendSms": [NSNumber numberWithBool:_sendSMSSwitch.on],
                    @"threshold": [_thresholdTextField.text isEqualToString:@""]? _subscribe.threshold: [NSNumber numberWithFloat:_thresholdTextField.text.floatValue],
                    @"isAbove": [NSNumber numberWithInt:[_thresholdTextField.text floatValue] < _subscribe.rate.floatValue]
                    }
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
              if([response statusOK]) {
                  [self.navigationController popViewControllerAnimated:YES];
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              InternetResponse *response = [[InternetResponse alloc] initWithError:error];
              switch ([response errorCode]) {
                  case ErrorCodeTokenError:
                      
                      break;
                      
                  default:
                      if (DEBUG) {
                          NSLog(@"Error code is %d", [response errorCode]);
                      }
                      [AlertTool showAlertWithTitle:@"Tip"
                                         andContent:@"Cannot modify this subscription, try again later."
                                   inViewController:self];
                      [self.navigationController popViewControllerAnimated:YES];
                      break;
              }
          }];
}

@end
