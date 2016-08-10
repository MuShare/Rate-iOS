//
//  EditSubscriptionTableViewController.h
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVGKit/SVGKit.h>
#import "DaoManager.h"

@interface EditSubscriptionTableViewController : UITableViewController <UITextViewDelegate>

@property (strong, nonatomic) Subscribe *subscribe;

@property (weak, nonatomic) IBOutlet SVGKFastImageView *fromImageView;
@property (weak, nonatomic) IBOutlet UILabel *fromCodeLabel;
@property (weak, nonatomic) IBOutlet SVGKFastImageView *toImageView;
@property (weak, nonatomic) IBOutlet UILabel *toCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *snameTextField;
@property (weak, nonatomic) IBOutlet UILabel *currentRateLabel;
@property (weak, nonatomic) IBOutlet UITextField *thresholdTextField;
@property (weak, nonatomic) IBOutlet UISwitch *enableSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *sendEmailSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *sendSMSSwitch;

@property (weak, nonatomic) IBOutlet UILabel *subscribeTipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *trendImageView;
@property (weak, nonatomic) IBOutlet UIImageView *snameImageView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *deleteSubscribeButton;

- (IBAction)editSubscribe:(UIBarButtonItem *)sender;
- (IBAction)deleteSubscribe:(id)sender;

@end
