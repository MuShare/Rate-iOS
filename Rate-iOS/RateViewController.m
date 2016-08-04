//
//  RateViewController.m
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/1/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "RateViewController.h"
#import "DaoManager.h"
#import "InternetTool.h"
#import "UserTool.h"
#import "CommonTool.h"

@interface RateViewController ()

@end

@implementation RateViewController {
    DaoManager *dao;
    AFHTTPSessionManager *manager;
    UserTool *user;
    Currency *fromCurrency;
    Currency *toCurrency;
    float currentRate;
    NSArray *rates;
    NSDate *start;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dao = [[DaoManager alloc] init];
    manager = [InternetTool getSessionManager];
    user = [[UserTool alloc] init];
    
    currentRate = [[_selectedRate valueForKey:@"value"] floatValue];
    
    fromCurrency = [dao.currencyDao getByCid:user.basedCurrencyId forLanguage:user.lan];
    toCurrency = [dao.currencyDao getByCid:[_selectedRate valueForKey:@"cid"] forLanguage:user.lan];
    
    _fromImageView.image = [SVGKImage imageNamed:[NSString stringWithFormat:@"%@.svg", fromCurrency.icon]];
    _toImageView.image = [SVGKImage imageNamed:[NSString stringWithFormat:@"%@.svg", toCurrency.icon]];
    [_fromButton setTitle:fromCurrency.code forState:UIControlStateNormal];
    [_toButton setTitle:toCurrency.code forState:UIControlStateNormal];
    _toRateTextFiled.placeholder = [NSString stringWithFormat:@"%f", currentRate];

    [_fromRateTextFiled addTarget:self action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
    [_toRateTextFiled addTarget:self action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
    [self setCloseKeyboardAccessoryForSender:_fromRateTextFiled];
    [self setCloseKeyboardAccessoryForSender:_toRateTextFiled];
    
    //Set chart
    _historyLineChartView.delegate = self;
    [_historyLineChartView animateWithXAxisDuration:0.5 yAxisDuration:1.0];
    
    NSDate *end = [NSDate date];
    start = [CommonTool getDateAfterNextDays:-30 fromDate:end];
    [manager GET:[InternetTool createUrl:@"api/rate/history"]
      parameters:@{
                    @"from": fromCurrency.cid,
                    @"to": toCurrency.cid,
                    @"start": [NSNumber numberWithLong:[CommonTool getUnixTimestamp:start]],
                    @"end": [NSNumber numberWithLong:[CommonTool getUnixTimestamp:end]]
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
        [xVals addObject:[NSString stringWithFormat:@"%@", [CommonTool formateDate:start withFormat:DateFormatYearMonthDayShort]]];
        start = [CommonTool getDateAfterNextDays:1 fromDate:start];
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
        set.highlightColor = [UIColor blueColor];//点击选中拐点的十字线的颜色
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

#pragma mark - ChartViewDelegate
- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight *)highlight {
    if(DEBUG) {
         NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidChange:(UITextField *)sender {
    if(DEBUG) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    float value = [sender.text floatValue];
    if(sender == _fromRateTextFiled) {
        _toRateTextFiled.placeholder = [NSString stringWithFormat:@"%f", value * currentRate];
    } else if(sender == _toRateTextFiled) {
        _fromRateTextFiled.placeholder = [NSString stringWithFormat:@"%f", value / currentRate];
    }
}

#pragma mark - Service
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
