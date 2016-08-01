//
//  RateViewController.m
//  Rate-iOS
//
//  Created by 李大爷的电脑 on 8/1/16.
//  Copyright © 2016 MuShare. All rights reserved.
//

#import "RateViewController.h"

@interface RateViewController ()

@end

@implementation RateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _historyLineChartView.delegate = self;//设置代理
    _historyLineChartView.xAxis.drawGridLinesEnabled = NO;//不绘制网格线
    _historyLineChartView.xAxis.labelPosition = XAxisLabelPositionBottom; //X轴的显示位置，默认是显示在上面的
    _historyLineChartView.rightAxis.enabled = NO;
    _historyLineChartView.leftAxis.enabled = NO;
    [self setData];
}

- (void)setData {
    int xVals_count = 100;//X轴上要显示多少条数据
    double maxYVal = 100;//Y轴的最大值
    
    //X轴上面需要显示的数据
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++) {
        [xVals addObject:[NSString stringWithFormat:@"%d", i+1]];
    }
    
    //对应Y轴上面需要显示的数据
    double val = 0;
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++) {
        double mult = maxYVal + 1;
        val += (double)(arc4random_uniform(mult));
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithValue:val xIndex:i];
        [yVals addObject:entry];
    }
    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithYVals:yVals label:@"CNY to JPY, 2016-06-01 ~ 2016-07-01"];
    //设置折线的样式
    set.drawValuesEnabled = NO;//是否在拐点处显示数据
    set.drawCirclesEnabled = NO;//是否绘制拐点
    //点击选中拐点的交互样式
    set.highlightEnabled = YES;//选中拐点,是否开启高亮效果(显示十字线)
    set.highlightColor = [UIColor blueColor];//点击选中拐点的十字线的颜色
    //第二种填充样式:渐变填充
    set.drawFilledEnabled = YES;//是否填充颜色
    NSArray *gradientColors = @[(id)[ChartColorTemplates colorFromString:@"#FFFFFFFF"].CGColor,
                                (id)[ChartColorTemplates colorFromString:@"#FF007FFF"].CGColor];
    CGGradientRef gradientRef = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
    set.fillAlpha = 0.3f;//透明度
    set.fill = [ChartFill fillWithLinearGradient:gradientRef angle:90.0f];//赋值填充颜色对象
    CGGradientRelease(gradientRef);//释放gradientRef

    //创建 LineChartData 对象, 此对象就是lineChartView需要最终数据对象
    _historyLineChartView.data = [[LineChartData alloc] initWithXVals:xVals
                                                             dataSets:[NSMutableArray arrayWithObject:set]];
}

#pragma mark - ChartViewDelegate

@end
