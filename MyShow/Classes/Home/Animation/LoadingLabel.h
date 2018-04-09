//
//  LoadingLabel.h
//  MyShow
//
//  Created by jianhua zhang on 2018/4/8.
//  Copyright © 2018年 花落永恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingLabel : UILabel

//富文本
@property (nonatomic, strong) NSMutableAttributedString *mutableAttText;
//放大的长度
@property (nonatomic, assign) NSInteger amplificationLength;
//中间最大的字体
@property (nonatomic, assign) NSInteger maxAmplificationFont;
//中间左边的字体
@property (nonatomic, assign) NSInteger maxLeftAmplificationFont;
//中间右边的字体
@property (nonatomic, assign) NSInteger maxRightlificationFont;

@property (nonatomic, strong) UIFont *minFont;

@property (nonatomic, assign) BOOL isRunning;
/*
 显示loadingLabel动画
 *  params cgColor (UIColor *).cgcolor的数组
 */
- (void)showLoadingView:(NSArray *)cgColor;
/*
 显示下划线
 */
- (void)showUnderLineLabel:(NSRange)textRange;

@end
