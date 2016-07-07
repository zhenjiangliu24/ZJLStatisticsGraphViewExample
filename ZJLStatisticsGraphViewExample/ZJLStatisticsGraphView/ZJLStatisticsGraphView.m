//
//  ZJLStatisticsGraphView.m
//  ZJLStatisticsGraphViewExample
//
//  Created by ZhongZhongzhong on 16/7/6.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ZJLStatisticsGraphView.h"

static const CGFloat MarginVertical = 30.0;
static const CGFloat MarginHorizontal = 30.0;
static const NSInteger YAxisMaxCount = 5;

@interface ZJLStatisticsGraphView()
@property (nonatomic, assign) CGRect graphRect;
@property (nonatomic, assign) NSInteger numberOfData;
@property (nonatomic, assign) CGFloat yAxisCount;
@property (nonatomic, assign) CGFloat xAxisPerDistance;
@property (nonatomic, assign) CGFloat yAxisPerDistance;
@property (nonatomic, assign) CGFloat maxYValue;
@property (nonatomic, assign) CGFloat graphWidth;
@property (nonatomic, assign) CGFloat graphHeight;
@end

@implementation ZJLStatisticsGraphView
- (instancetype)initWithFrame:(CGRect)frame data:(NSArray<ZJLStatisticsPoint *> *)data
{
    if (self = [super initWithFrame:frame]) {
        _graphRect = frame;
        _datas = [data mutableCopy];
        _numberOfData = data.count;
    }
    return self;
}

#pragma mark - draw the graph
- (void)drawGraphWithLineType:(LineType)lineType pointType:(PointType)pointType
{
    [self setupProperties];
    [self removeAllSubLayers];
    [self drawAxis];
    if (self.isShowBar) {
        [self drawBar];
    }
}

#pragma mark - set up properties
- (void)setupProperties
{
    _yAxisCount = _numberOfData<=YAxisMaxCount?_numberOfData:YAxisMaxCount;
    _xAxisPerDistance = (CGFloat)((_graphRect.size.width - 2*MarginHorizontal)/_numberOfData);
    _yAxisPerDistance = (CGFloat)((_graphRect.size.height - 2*MarginVertical)/_yAxisCount);
    _graphWidth = _graphRect.size.width - 2*MarginHorizontal;
    _graphHeight = _graphRect.size.height - 2*MarginVertical;
    CGFloat maxY = CGFLOAT_MIN;
    for (ZJLStatisticsPoint *point in _datas) {
        if (point.yValue > maxY) {
            maxY = point.yValue;
        }
    }
    _maxYValue = maxY;
}

#pragma mark - remove all sub layers
- (void)removeAllSubLayers
{
    NSArray *layers = [self.layer.sublayers mutableCopy];
    for (CAShapeLayer *layer in layers) {
        [layer removeFromSuperlayer];
    }
}

#pragma  mark - draw axis
- (void)drawAxis
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //draw x,y line
    [path moveToPoint:CGPointMake(MarginHorizontal, MarginVertical/2 - 5)];
    [path addLineToPoint:CGPointMake(MarginHorizontal, CGRectGetHeight(_graphRect)-MarginVertical)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(_graphRect) - (MarginHorizontal/2 - 5), CGRectGetHeight(_graphRect)-MarginVertical)];
    
    //draw x axis arrow
    [path moveToPoint:CGPointMake(MarginHorizontal - 5, MarginVertical/ 2.0 + 4)];
    [path addLineToPoint:CGPointMake(MarginHorizontal, MarginVertical / 2.0 - 4)];
    [path addLineToPoint:CGPointMake(MarginHorizontal + 5, MarginVertical/ 2.0 + 4)];
    
    ///draw y axis arrow
    [path moveToPoint:CGPointMake(CGRectGetWidth(_graphRect) - MarginHorizontal / 2.0 - 4, CGRectGetHeight(_graphRect) - MarginVertical - 5)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(_graphRect) - MarginHorizontal / 2.0 + 5, CGRectGetHeight(_graphRect) - MarginVertical)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(_graphRect) - MarginHorizontal / 2.0 - 4, CGRectGetHeight(_graphRect) - MarginVertical + 5)];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = _lineColor?_lineColor.CGColor:[UIColor blackColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 2.0;
    [self.layer addSublayer:layer];
}

#pragma mark - draw bar
- (void)drawBar
{
    
}
@end
