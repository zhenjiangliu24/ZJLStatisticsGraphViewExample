//
//  ZJLStatisticsGraphView.h
//  ZJLStatisticsGraphViewExample
//
//  Created by ZhongZhongzhong on 16/7/6.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LineType)
{
    LineType_Straight,
    LineType_Curve
};

typedef NS_ENUM(NSInteger, PointType)
{
    PointType_Circle,
    PointType_Rect
};

@class ZJLStatisticsPoint;

@interface ZJLStatisticsGraphView : UIView
@property (nonatomic, strong) NSMutableArray<ZJLStatisticsPoint *> *datas;
@property (nonatomic, assign) BOOL isGrid;
@property (nonatomic, assign) BOOL isShowValue;
@property (nonatomic, assign) BOOL isShowPoint;
@property (nonatomic, assign) BOOL isShowBar;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *pointColor;

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray<ZJLStatisticsPoint *> *)data;
- (void)drawGraphWithLineType:(LineType)lineType pointType:(PointType)pointType;
@end

#pragma mark - point object
@interface ZJLStatisticsPoint : NSObject
@property (nonatomic, assign) CGFloat xValue;
@property (nonatomic, assign) CGFloat yValue;
@end


