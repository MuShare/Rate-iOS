//
//  EditSubscriptionTableViewController.m
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "EditSubscriptionTableViewController.h"
#import "InternetTool.h"

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
    //self.navigationController.navigationBar.titl = _subscribe.sname;
    _fromImageView.image = [SVGKImage imageNamed:[NSString stringWithFormat:@"%@.svg", _subscribe.from.icon]];
    _toImageView.image = [SVGKImage imageNamed:[NSString stringWithFormat:@"%@.svg", _subscribe.to.icon]];
    _fromCodeLabel.text = _subscribe.from.code;
    _toCodeLabel.text = _subscribe.to.code;
    _currentRateLabel.text = [NSString stringWithFormat:@"%.3f", _subscribe.rate.floatValue];
    _thresholdTextField.placeholder = [NSString stringWithFormat:@"%.3f", _subscribe.threshold.floatValue];
    [_thresholdTextField addTarget:self action:@selector(thresholdTextFieldDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
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
    if([sender.text isEqualToString:@""]) {
        _saveBarButtonItem.enabled = NO;
        _subscribeTipLabel.hidden = YES;
    } else {
        _saveBarButtonItem.enabled = YES;
        _subscribeTipLabel.hidden = NO;
    }
    float rate = [sender.text floatValue];
    if (rate > _subscribe.rate.floatValue) {
        _subscribeTipLabel.text = @"Alert me above";
        _subscribeDownImageView.hidden = YES;
        _subscribeUpImageView.hidden = NO;
    } else {
        _subscribeTipLabel.text = @"Alert me blow";
        _subscribeUpImageView.hidden = YES;
        _subscribeDownImageView.hidden = NO;
    }
}

#pragma mark - Action
- (IBAction)updateSubscribe:(id)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [manager POST:[InternetTool createUrl:@"api/user/subscribe/update"]
       parameters:@{
                    @"sid": _subscribe.sid,
                    @"sname": _subscribe.sname,
                    @"isEnable": [NSNumber numberWithBool:_enableSwitch.on],
                    @"isSendEmail": [NSNumber numberWithBool:_sendEmailSwitch.on],
                    @"isSendSms": [NSNumber numberWithBool:_sendSMSSwitch.on],
                    @"threshold": [NSNumber numberWithFloat:_thresholdTextField.text.floatValue],
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
                      break;
              }
          }];
}

- (IBAction)deleteSubscribe:(id)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
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
}
@end
