//
//  RateViewController.h
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/1/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVGKit/SVGKit.h>
#import "Rate-iOS-Bridging-Header.h"

@interface RateViewController : UIViewController <ChartViewDelegate>

@property (weak, nonatomic) IBOutlet SVGKFastImageView *fromImageView;
@property (weak, nonatomic) IBOutlet SVGKFastImageView *toImageView;
@property (weak, nonatomic) IBOutlet UIButton *fromButton;
@property (weak, nonatomic) IBOutlet UIButton *toButton;
@property (weak, nonatomic) IBOutlet UITextField *fromRateTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *toRateTextFiled;
@property (weak, nonatomic) IBOutlet LineChartView *historyLineChartView;

@end
