//
//  ViewController.m
//  ZJLStatisticsGraphViewExample
//
//  Created by ZhongZhongzhong on 16/7/6.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ViewController.h"
#import "ZJLStatisticsGraphView/ZJLStatisticsGraphView.h"

@interface ViewController ()
@property (nonatomic, strong) ZJLStatisticsGraphView *lineView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ZJLStatisticsPoint *point1 = [[ZJLStatisticsPoint alloc] initWithX:1 Y:3.0];
    ZJLStatisticsPoint *point2 = [[ZJLStatisticsPoint alloc] initWithX:2 Y:28.0];
    ZJLStatisticsPoint *point3 = [[ZJLStatisticsPoint alloc] initWithX:3 Y:15.0];
    ZJLStatisticsPoint *point4 = [[ZJLStatisticsPoint alloc] initWithX:4 Y:9.0];
    ZJLStatisticsPoint *point5 = [[ZJLStatisticsPoint alloc] initWithX:5 Y:20.0];
    NSArray *data = @[point1,point2,point3,point4,point5];
    self.lineView = [[ZJLStatisticsGraphView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-40, 200) data:data];
    self.lineView.backgroundColor = [UIColor grayColor];
    self.lineView.isShowBar = YES;
    self.lineView.isGrid = YES;
    [self.view addSubview:self.lineView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.lineView drawGraphWithLineType:LineType_Straight pointType:PointType_Circle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
