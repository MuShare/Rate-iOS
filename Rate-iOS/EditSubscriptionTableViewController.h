//
//  EditSubscriptionTableViewController.h
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/3/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVGKit/SVGKit.h>

@interface EditSubscriptionTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet SVGKFastImageView *fromImageView;
@property (weak, nonatomic) IBOutlet UILabel *fromCodeLabel;
@property (weak, nonatomic) IBOutlet SVGKFastImageView *toImageView;
@property (weak, nonatomic) IBOutlet UILabel *toCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentRateLabel;
@property (weak, nonatomic) IBOutlet UITextField *thresholdTextField;
@property (weak, nonatomic) IBOutlet UISwitch *enableSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *sendEmailSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *sendSMSSwitch;

@end
