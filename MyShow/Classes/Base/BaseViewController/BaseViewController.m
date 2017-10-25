//
//  BaseViewController.m
//  DoctorApp
//
//  Created by 郭强 on 16/7/23.
//  Copyright © 2016年 郭强. All rights reserved.
//

#import "BaseViewController.h"
#import "Reachability.h"
#import "LoginViewController.h"
#import <ShareSDKUI/ShareSDKUI.h>

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


@property (nonatomic, strong) Reachability *reachability;




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
    [self initErrorView];
        
    self.navigationController.navigationBar.translucent = NO;

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //设置导航栏颜色
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    
    if ([self.view.backgroundColor isEqual:[UIColor clearColor]]) {
        self.view.backgroundColor = BackGroundColor;
    }
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //弹出登录界面通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popLoginViewController) name:PopLoginViewController object:nil];

    //注册网络通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
        
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PopLoginViewController object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

#pragma 检测网络状态
-(void)networkStateChange{
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    if([wifi currentReachabilityStatus]==NotReachable){
        [self.view makeToast:@"你已关闭网络连接!"];
    }
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


#pragma mark --- 初始化错误界面
-(void)initErrorView
{
    if (self.noNetworkView!=nil) {
        [self.noNetworkView removeFromSuperview];
    }
    self.noNetworkView = [[NoNetworkView alloc]initWithFrame:CGRectMake(0,0,kMainScreenOfWidth ,kMainScreenOfHeight)];
    self.noNetworkView.hidden = true;
    [self.view addSubview:self.noNetworkView];
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
- (void)popViewControllerAnimated:(NSInteger)index animated:(BOOL)animated{
    if (self.navigationController.viewControllers.count >= index + 2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - index - 2] animated:animated];
    }else{
        [self.navigationController popViewControllerAnimated:animated];
    }
}
- (void)popToViewControllerAnimated:(UIViewController*)viewController animated:(BOOL)animated{
    [self.navigationController popToViewController:viewController animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    self.firstPushTimestamp = 0;
    self.secondPushTimestampl = 0;
}
#pragma mark 弹出登录界面
- (void)showLoginViewController{
    
    APPDelegate.token = @"";
    APPDelegate.uid = @"";
    
    [LoginViewController checkLogin:self complete:^(BOOL isLogin){
        
    }];
}
- (void)shareText:(NSString *)text withImg:(NSURL *)img withUrl:(NSString *)url withTitle:(NSString *)title SSDKPlatformType:(id)type{
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupShareParamsByText:text
                                     images:img
                                        url:[NSURL URLWithString:url]
                                      title:title
                                       type:SSDKContentTypeAuto];
    
    [shareParams SSDKSetupWeChatParamsByText:text title:title url:[NSURL URLWithString:url] thumbImage:nil image:img musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台
    NSArray *shareType;
    if (type != nil) {
        shareType = @[type];
    }else{
        shareType = @[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)];
    }
    [ShareSDK showShareActionSheet:nil
                             items:shareType
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       default:
                           break;
                   }}];
    
    //分享平台 NSUInteger shareType = SSDKPlatformSubTypeWechatSession;
//    [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//        switch (state) {
//            case SSDKResponseStateSuccess:
//            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
//                break;
//            }
//            case SSDKResponseStateFail:
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                message:[NSString stringWithFormat:@"%@",error]
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil, nil];
//                [alert show];
//                break;
//            }
//            default:
//                break;
//        }}];
}
@end
