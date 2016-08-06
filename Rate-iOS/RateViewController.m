//
//  RateViewController.m
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/1/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "RateViewController.h"
#import "InternetTool.h"
#import "UserTool.h"
#import "CommonTool.h"

//Fix regulation cause by leading constraint
#define LeadingConstraintRegulationWidth 20

#define TrailingConstraintRegulationWidth 8

@interface RateViewController ()

@end

@implementation RateViewController {
    DaoManager *dao;
    AFHTTPSessionManager *manager;
    UserTool *user;
    float currentRate;
    int selectedTimeIndex;
    NSArray *rates;
    NSDate *start;
    NSDateFormatter *dateFormatter;
    float screenWitdh, historyEntryWith;
}

static const int historySearchDays[5] = {30, 90, 180, 365, 3*365};

- (void)viewDidLoad {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [super viewDidLoad];
    dao = [[DaoManager alloc] init];
    manager = [InternetTool getSessionManager];
    user = [[UserTool alloc] init];
    _fromCurrency = [dao.currencyDao getByCid:user.basedCurrencyId forLanguage:user.lan];
    _toCurrency = [dao.currencyDao getByCid:[_selectedRate valueForKey:@"cid"] forLanguage:user.lan];
    
    //Show history of last 7 days as default
    selectedTimeIndex = 0;
    //Set chart
    _historyLineChartView.delegate = self;
    [_historyLineChartView animateWithXAxisDuration:0.5 yAxisDuration:1.0];
    
    //Initial date formatter using local language
    [self initDateFormatter];
    
    //Initial width info
    screenWitdh = self.view.frame.size.width;
    historyEntryWith = _historyEntryView.frame.size.width;
}

- (void)viewWillAppear:(BOOL)animated {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self refreshCurrency];
    [_fromRateTextFiled addTarget:self action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
    [_toRateTextFiled addTarget:self action:@selector(textFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
    [self setCloseKeyboardAccessoryForSender:_fromRateTextFiled];
    [self setCloseKeyboardAccessoryForSender:_toRateTextFiled];
    
    //Load current rate
    [self loadCurrent];

    //Load history rate
    [self loadHistory:historySearchDays[selectedTimeIndex]];
}

#pragma mark - Action

- (IBAction)swapCurrency:(id)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    //Swap currency info
    Currency *tmpCurrency = _toCurrency;
    _toCurrency = _fromCurrency;
    _fromCurrency = tmpCurrency;
    [self refreshCurrency];
    //Swap rate value
    NSString *tmpPlacehoder = _toRateTextFiled.placeholder;
    _toRateTextFiled.placeholder = _fromRateTextFiled.placeholder;
    _fromRateTextFiled.placeholder = tmpPlacehoder;
    //Reload history data
    [self loadHistory:historySearchDays[selectedTimeIndex]];
}

- (IBAction)changeDates:(id)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    selectedTimeIndex = (int)[sender selectedSegmentIndex];
    [self loadHistory:historySearchDays[selectedTimeIndex]];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if ([segue.identifier isEqualToString:@"selectFromCurrencySegue"]) {
        [segue.destinationViewController setValue:@YES forKey:@"selectable"];
        [segue.destinationViewController setValue:@"fromCurrency" forKey:@"currencyAttributeName"];
    } else if ([segue.identifier isEqualToString:@"selectToCurrencySegue"]) {
        [segue.destinationViewController setValue:@YES forKey:@"selectable"];
        [segue.destinationViewController setValue:@"toCurrency" forKey:@"currencyAttributeName"];
    }
}

#pragma mark - ChartViewDelegate
- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight *)highlight {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        NSLog(@"Selected chartDataEntry %@", entry);
    }
    //Show history entry information
    _historyEntryView.hidden = NO;

    float xOffset = screenWitdh / (rates.count - 1) * entry.xIndex - historyEntryWith / 2 - LeadingConstraintRegulationWidth;
    if(xOffset < - LeadingConstraintRegulationWidth) {
        xOffset = - LeadingConstraintRegulationWidth;
    } else if (xOffset > screenWitdh - historyEntryWith - TrailingConstraintRegulationWidth) {
        xOffset = screenWitdh - historyEntryWith -TrailingConstraintRegulationWidth;
    }
    _historyEntryLeadingLayoutConstraint.constant = xOffset;
    
    NSDate *date = [CommonTool getDateAfterNextDays:(int)(-entry.xIndex) fromDate:[NSDate date]];
    _historyDateLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    _historyRateLebel.text = [NSString stringWithFormat:@"%g", entry.value];
}

- (void)chartValueNothingSelected:(ChartViewBase *)chartView {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    _historyEntryView.hidden = YES;
}

- (void)chartScaled:(ChartViewBase *)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        NSLog(@"chartScaled scaleX = %f, scaleY = %f", scaleX, scaleY);
    }
}

- (void)chartTranslated:(ChartViewBase *)chartView dX:(CGFloat)dX dY:(CGFloat)dY {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        NSLog(@"chartTranslated dX = %f, dY = %f", dX, dY);
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    float value = [sender.text floatValue];
    if(sender == _fromRateTextFiled) {
        _toRateTextFiled.placeholder = [NSString stringWithFormat:@"%.4f", value * currentRate];
    } else if(sender == _toRateTextFiled) {
        _fromRateTextFiled.placeholder = [NSString stringWithFormat:@"%.4f", value / currentRate];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

#pragma mark - Service
- (void)initDateFormatter {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
}

- (void)refreshCurrency {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }

    _fromImageView.image = [SVGKImage imageNamed:[NSString stringWithFormat:@"%@.svg", _fromCurrency.icon]];
    _toImageView.image = [SVGKImage imageNamed:[NSString stringWithFormat:@"%@.svg", _toCurrency.icon]];
    [_fromButton setTitle:_fromCurrency.code forState:UIControlStateNormal];
    _fromNameLabel.text = _fromCurrency.name;
    _toNameLabel.text = _toCurrency.name;
    [_toButton setTitle:_toCurrency.code forState:UIControlStateNormal];
}

- (void)loadCurrent {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
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
                 [self refreshCurrentRate];
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if(DEBUG) {
                 NSLog(@"Server error: %@", error.localizedDescription);
             }
         }];
}

- (void)refreshCurrentRate {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    _fromRateTextFiled.placeholder = @"1";
    _toRateTextFiled.placeholder = [NSString stringWithFormat:@"%.4f", currentRate];
}

- (void)loadHistory:(int)days {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    NSDate *end = [NSDate date];
    start = [CommonTool getDateAfterNextDays:-days fromDate:end];
    long long startTimestamp = [CommonTool getUnixTimestamp:start];
    long long endTimpstamp = [CommonTool getUnixTimestamp:end];
    if(DEBUG) {
        NSLog(@"Loading history data from %@ to %@, %d days. Timestamp is (%lld, %lld)", start, end, days, startTimestamp, endTimpstamp);
    }
    [manager GET:[InternetTool createUrl:@"api/rate/history"]
      parameters:@{
                   @"from": _fromCurrency.cid,
                   @"to": _toCurrency.cid,
                   @"start": [NSNumber numberWithLongLong:startTimestamp],
                   @"end": [NSNumber numberWithLongLong:endTimpstamp]
                   }
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             InternetResponse *response = [[InternetResponse alloc] initWithResponseObject:responseObject];
             if([response statusOK]) {
                 rates = [[response getResponseResult] objectForKey:@"data"];
                 [self setDataCount];
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             if(DEBUG) {
                 NSLog(@"Server error: %@", error.localizedDescription);
             }
         }];
    
}

- (void)setDataCount {
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < rates.count; i++) {
        [xVals addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < rates.count; i++) {
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithValue:[[rates objectAtIndex:i] doubleValue] xIndex:i];
        [yVals1 addObject:entry];
    }
    
    LineChartDataSet *set = nil;
    if (_historyLineChartView.data.dataSetCount > 0) {
        set = (LineChartDataSet *)_historyLineChartView.data.dataSets[0];
        set.yVals = yVals1;
        _historyLineChartView.data.xValsObjc = xVals;
        [_historyLineChartView.data notifyDataChanged];
        [_historyLineChartView notifyDataSetChanged];
    } else {
        set = [[LineChartDataSet alloc] initWithYVals:yVals1 label:nil];
        //设置折线的样式
        set.drawCubicEnabled = YES;
        set.cubicIntensity = 0.2;
        set.drawCirclesEnabled = NO;
        //点击选中拐点的交互样式
        set.highlightEnabled = YES;//选中拐点,是否开启高亮效果(显示十字线)
        set.highlightColor = [UIColor colorWithRed:31/255.0 green:199/255.0 blue:149/255.0 alpha:1.0];//点击选中拐点的十字线的颜色
        //填充样式:渐变填充
        set.drawFilledEnabled = YES;//是否填充颜色
        NSArray *gradientColors = @[(id)[ChartColorTemplates colorFromString:@"#FFFFFFFF"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#FF007FFF"].CGColor];
        CGGradientRef gradientRef = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        set.fillAlpha = 0.3f;//透明度
        set.fill = [ChartFill fillWithLinearGradient:gradientRef angle:90.0f];//赋值填充颜色对象
        CGGradientRelease(gradientRef);//释放gradientRef
        //创建 LineChartData 对象
        LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSet:set];
        [data setDrawValues:NO];
        _historyLineChartView.data = data;
    }
}

//为虚拟键盘设置关闭按钮
- (void)setCloseKeyboardAccessoryForSender:(id)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // 创建一个UIToolBar工具条
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.window.frame.size.width, 35)];
    // 设置工具条风格
    [topView setBarStyle:UIBarStyleDefault];
    // 为工具条创建第2个“按钮”，该按钮只是一片可伸缩的空白区。
    UIBarButtonItem* spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                     target:self
                                                                                     action:nil];
    // 为工具条创建第3个“按钮”，单击该按钮会激发editFinish方法
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self
                                                                                    action:@selector(editFinish)];
    doneButtonItem.tintColor = [UIColor colorWithRed:38/255.0 green:186/255.0 blue:152/255.0 alpha:1.0];
    // 以3个按钮创建NSArray集合
    NSArray * buttonsArray = [NSArray arrayWithObjects:spaceButtonItem, doneButtonItem, nil];
    // 为UIToolBar设置按钮
    [topView setItems:buttonsArray];
    [sender setInputAccessoryView:topView];
}

//键盘完成输入后关闭
- (void)editFinish {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    for(id input in self.view.subviews){
        if([input isKindOfClass:[UITextField class]]){
            UITextField *this = input;
            if([this isFirstResponder]) {
                [this resignFirstResponder];
                this.placeholder = this.text;
                this.text = @"";
            }
        }
    }
}

@end
