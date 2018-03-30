//
//  ZJHAlertViewController.h
//  MyShow
//
//  Created by jianhua zhang on 2018/3/27.
//  Copyright © 2018年 花落永恒. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZJHAlertStyleDefault,//默认
    ZJHAlertStyleCommon,//普通弹窗
} ZJHAlertStyle;

typedef enum : NSUInteger {
    ZJHAlertShowStyleDefault,//默认
} ZJHAlertShowStyle;

typedef void(^ZJHAlertBlock)(NSInteger selectIndex);


@protocol ZJHAlertViewControllerDelegate<NSObject>

@end

@interface ZJHAlertViewController : UIViewController

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *titleView;

@property (nonatomic, strong) UILabel *messageView;

@property (assign, nonatomic) ZJHAlertStyle zAlertStyle;

@property (copy, nonatomic) ZJHAlertBlock selectBlock;
/** ZJHAlertViewControllerDelegate
 */
@property (strong, nonatomic) id<ZJHAlertViewControllerDelegate> delegate;

/*
 * @brief init
 * @params style title message button
 */
- (instancetype)initWithAlertStyle:(ZJHAlertStyle)alertStyle Title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles clickBlock:(ZJHAlertBlock)selectBlock;

- (void)alertShowWithStyle:(ZJHAlertShowStyle)alertStyle;

@end
