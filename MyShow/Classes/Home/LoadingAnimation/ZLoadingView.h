//
//  ZLoadingView.h
//  MyShow
//
//  Created by jianhua zhang on 2018/4/9.
//  Copyright © 2018年 花落永恒. All rights reserved.
//

#import <UIKit/UIKit.h>

#define blueToothWidth 15

@interface ZLoadingView : UIView

/*
 * @brief 展示加载中的视图
 */
- (void)showLoadingView;
/*
 * @brief show BlueToothConnectView
 * @param superView
 */
- (void)showBlueToothConnecting:(UIView *)superView;

- (void)hiddenBlueToothConnecting;

@end
