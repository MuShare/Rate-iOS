//
//  AddSubscribeTableViewController.h
//  Rate-iOS
//
//  Created by lidaye on 8/1/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaoManager.h"

@interface AddSubscribeTableViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) Currency *fromCurrency;
@property (strong, nonatomic) Currency *toCurrency;

@property (weak, nonatomic) IBOutlet UIImageView *subscribeUpImageView;
@property (weak, nonatomic) IBOutlet UIImageView *subscribeDownImageView;
@property (weak, nonatomic) IBOutlet UILabel *subscribeTipLabel;

@property (weak, nonatomic) IBOutlet UITextField *subscribeNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *thresholdTextField;
@property (weak, nonatomic) IBOutlet UIButton *fromCurrencyButton;
@property (weak, nonatomic) IBOutlet UIButton *toCurrencyButton;
@property (weak, nonatomic) IBOutlet UISwitch *enableSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *sendEmailSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *sendSMSSwitch;

- (IBAction)saveSubscribe:(id)sender;
- (IBAction)finishEdit:(id)sender;

@end
