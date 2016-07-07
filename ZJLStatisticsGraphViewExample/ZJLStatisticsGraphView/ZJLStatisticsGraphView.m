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
    if (self.isGrid) {
        [self drawGrid];
    }
    [self drawLineWithType:lineType];
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
    
    [self drawAxisLabel];
}

- (void)drawAxisLabel
{
    //y axis label
    for (int i = 0; i<=_yAxisCount; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, MarginVertical+_yAxisPerDistance*i - _yAxisPerDistance/2, MarginHorizontal-1, _yAxisPerDistance)];
        label.textColor = [UIColor blackColor];
        label.text = [NSString stringWithFormat:@"%d",(int)(_maxYValue/_yAxisCount*(_yAxisCount-i))];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
    }
    //x axis label
    for (int i = 1; i<=_numberOfData; i++) {
        ZJLStatisticsPoint *point = _datas[i-1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(MarginHorizontal+i*_xAxisPerDistance-_xAxisPerDistance/2, CGRectGetHeight(_graphRect)-MarginVertical, _xAxisPerDistance, MarginVertical-1)];
        label.textColor = [UIColor blackColor];
        label.text = [NSString stringWithFormat:@"%.1f",point.xValue];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
    }
}

#pragma mark - draw bar
- (void)drawBar
{
    for (int i = 0; i<_numberOfData; i++) {
        ZJLStatisticsPoint *point = _datas[i];
        CGPoint start = CGPointMake(MarginVertical + (i+1)*_xAxisPerDistance, MarginVertical+(1-point.yValue/_maxYValue)*_graphHeight);
        CGFloat width = _xAxisPerDistance<=20?10:20;
        CGRect bar = CGRectMake(start.x-width/2, start.y, width, CGRectGetHeight(_graphRect)-MarginVertical-start.y);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:bar];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;
        layer.strokeColor = _barColor?_barColor.CGColor:[UIColor blueColor].CGColor;
        layer.fillColor = _barColor?_barColor.CGColor:[UIColor blueColor].CGColor;;
        
        [self.layer addSublayer:layer];
    }
}

#pragma mark - draw grid
- (void)drawGrid
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //draw horizontal grid line
    for (int i = 0; i<_yAxisCount; i++) {
        [path moveToPoint:CGPointMake(MarginHorizontal, MarginVertical + _yAxisPerDistance*i)];
        [path addLineToPoint:CGPointMake(MarginHorizontal + _graphWidth, MarginVertical + _yAxisPerDistance*i)];
    }
    
    //draw vertical grid line
    for (int i = 1; i<=_numberOfData; i++) {
        [path moveToPoint:CGPointMake(MarginHorizontal+_xAxisPerDistance*i, MarginVertical)];
        [path addLineToPoint:CGPointMake(MarginHorizontal+_xAxisPerDistance*i, MarginVertical+_graphHeight)];
    }
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 0.5;
    
    [self.layer addSublayer:layer];
}

#pragma mark - draw line
- (void)drawLineWithType:(LineType)type
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    ZJLStatisticsPoint *startPoint = _datas[0];
    [path moveToPoint:CGPointMake(MarginHorizontal+_xAxisPerDistance, MarginVertical+(1-startPoint.yValue/_maxYValue)*_graphHeight)];
    switch (type) {
        case LineType_Straight:
            for (int i = 1; i<_numberOfData; i++) {
                ZJLStatisticsPoint *now = _datas[i];
                [path addLineToPoint:CGPointMake(MarginHorizontal+_xAxisPerDistance*(i+1), MarginVertical+(1-now.yValue/_maxYValue)*_graphHeight)];
            }
            break;
            
        case LineType_Curve:
            for (int i = 1; i<_numberOfData; i++) {
                ZJLStatisticsPoint *prePoint = _datas[i-1];
                ZJLStatisticsPoint *nowPoint = _datas[i];
                CGPoint pre = CGPointMake(MarginHorizontal+_xAxisPerDistance*i, MarginVertical+(1-prePoint.yValue/_maxYValue)*_graphHeight);
                CGPoint now = CGPointMake(MarginHorizontal+_xAxisPerDistance*(i+1), MarginVertical+(1-nowPoint.yValue/_maxYValue)*_graphHeight);
                [path addCurveToPoint:now controlPoint1:CGPointMake((pre.x+now.x)/2, pre.y) controlPoint2:CGPointMake((pre.x+now.x)/2, now.y)];
            }
            break;
    }
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = _lineColor?_lineColor.CGColor:[UIColor redColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    [self.layer addSublayer:layer];
}
@end

@implementation ZJLStatisticsPoint

- (instancetype)initWithX:(CGFloat)xValue Y:(CGFloat)yValue
{
    if (self = [super init]) {
        _xValue = xValue;
        _yValue = yValue;
    }
    return self;
}

@end
