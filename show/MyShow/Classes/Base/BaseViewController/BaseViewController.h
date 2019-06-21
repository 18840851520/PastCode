//
//  BaseViewController.h
//  DoctorApp
//
//  Created by on 16/7/23.
//  Copyright © 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>

@interface BaseViewController : UIViewController

/**
 *  右边按钮
 */
@property (nonatomic,strong)UIBarButtonItem* rightButtonItem;

/**
 *  右边按钮
 *
 *  @param nonatomic
 *  @param strong
 *
 *  @return
 */
@property (nonatomic,strong)UIButton *rightButton;

/**
 *  导航栏返回按钮
 */
@property (nonatomic, strong) UIButton * backButton;
/**
 *  push到下个控制器
 *
 *  @param viewController
 */
- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated;
/**
 *  返回
 */
- (void)backAction;
/**
 *  销毁
 */
- (void)dismissViewControllerAnimated;
/**
 *  直接返回到上个界面
 *  @return
 */
- (void)popViewControllerAnimated:(BOOL)animated;

/**
 *  返回到指定界面
 *  @param viewController
 *  @param animated
 */
- (void)popToViewControllerAnimated:(UIViewController*)viewController animated:(BOOL)animated;

/**
 *  右边按钮事件
 */
- (void)rightItemAction;

- (void)showLoginViewController;

@end
