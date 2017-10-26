//
//  BaseViewController.m
//  DoctorApp
//
//  Created by 花落永恒 on 16/7/23.
//  Copyright © 2016年 花落永恒. All rights reserved.
//

#import "BaseViewController.h"

#pragma mark 记录登录次数 以防二次出现
static NSInteger loginCount = 0;

@interface BaseViewController ()

/**
 *  第一次的push 时间
 */
@property(nonatomic,assign)double firstPushTimestamp;
/**
 * 第二次push 的时间
 */
@property(nonatomic,assign)double secondPushTimestampl;

@end

@implementation BaseViewController

//状态栏字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UINavigationBar *navigationBar = [[self navigationController] navigationBar];
    CGRect frame = [navigationBar frame];
    frame.size.height = 44.f;
    [navigationBar setFrame:frame];
    
    self.firstPushTimestamp = 0;
    self.secondPushTimestampl = 0;
    loginCount = 0;
    [self withBackView];
    
    [self withRightItem];
        
    self.navigationController.navigationBar.translucent = NO;

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}

#pragma mark 弹出登录界面
- (void)popLoginViewController{
    if (loginCount >= 1) {
        return;
    }
    loginCount = 1;
    [self showLoginViewController];
}

#pragma mark 弹出无网络提示
- (void)popNoNetWork{

}

#pragma mark 返回按钮
- (void)withBackView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    flexSpacer.width = -15;
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame =CGRectMake(0, 0, 44, 44);
    [self.backButton setImage:[UIImage imageNamed:@"icon_nav_back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem=[[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:flexSpacer, leftItem, nil];
}

#pragma mark 创建右边Item
- (void)withRightItem{
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [self.rightButton addTarget:self action:@selector(rightItemAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.rightButtonItem = rightItem;
    
}


#pragma mark 右边按钮
- (void)rightItemAction{

}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissViewControllerAnimated{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated{
    
    NSDate * date = [NSDate date];
    if(self.firstPushTimestamp==0){
        self.firstPushTimestamp = [date timeIntervalSinceReferenceDate];
    }else{
        self.secondPushTimestampl = [date timeIntervalSinceReferenceDate];
    }
    if(self.secondPushTimestampl > 0 ){
        double timestampl = self.secondPushTimestampl - self.firstPushTimestamp;
        if(timestampl < 3){
            return;
        }
    }
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:animated];
}
- (void)popViewControllerAnimated:(BOOL)animated{
    [self.navigationController popViewControllerAnimated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    self.firstPushTimestamp = 0;
    self.secondPushTimestampl = 0;
}
@end
