//
//  ZLoadingView.h
//  MyShow
//
//  Created by jianhua zhang on 2018/4/9.
//  Copyright © 2018年 花落永恒. All rights reserved.
//

#import <UIKit/UIKit.h>

////lineWidth 是线的宽度

#define blueToothWidth 15

#define loadingLineWidth 5.f
//loading 执行时间
#define loadingDuration  2.f
//failwidth 是❌号左边到中心点的距离
#define failWidth 15.f
#define failLineWidth 3.f

@interface ZLoadingView : UIView

@property (nonatomic, strong) UIColor *loadingStrokeColor;

@property (nonatomic, strong) UIColor *fillColor;

@property (nonatomic, strong) UIColor *failColor;


/*
 * @brief 展示加载中的视图
 */
- (void)showLoadingView;

- (void)showEndLoading;
/*
 * @brief show BlueToothConnectView
 * @param superView
 */
- (void)showBlueToothConnecting:(UIView *)superView;

- (void)hiddenBlueToothConnecting;

- (void)showSuccess;

- (void)showFailed;

- (void)showWarning;

@end
