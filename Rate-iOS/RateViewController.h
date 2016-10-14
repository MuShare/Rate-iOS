//
//  RateViewController.h
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/1/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaoManager.h"
#import "Rate-iOS-Bridging-Header.h"

@interface RateViewController : UIViewController <ChartViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) Currency *fromCurrency;
@property (strong, nonatomic) Currency *toCurrency;
@property (nonatomic) NSNumber *rate;

@property (weak, nonatomic) IBOutlet UIImageView *fromImageView;
@property (weak, nonatomic) IBOutlet UIImageView *toImageView;
@property (weak, nonatomic) IBOutlet UIButton *fromButton;
@property (weak, nonatomic) IBOutlet UILabel *fromNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *toButton;
@property (weak, nonatomic) IBOutlet UILabel *toNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *fromRateTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *toRateTextFiled;
@property (weak, nonatomic) IBOutlet LineChartView *historyLineChartView;
@property (weak, nonatomic) IBOutlet UILabel *historyDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *historyRateLebel;

@property (weak, nonatomic) IBOutlet UIView *historyEntryView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *historyEntryLeadingLayoutConstraint;

- (IBAction)swapCurrency:(id)sender;

- (IBAction)changeDates:(id)sender;

@end
