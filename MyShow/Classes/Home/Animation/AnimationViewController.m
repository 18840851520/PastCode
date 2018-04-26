//
//  AnimationViewController.m
//  MyShow
//
//  Created by jianhua zhang on 2018/4/8.
//  Copyright © 2018年 花落永恒. All rights reserved.
//

#import "AnimationViewController.h"
#import "LoadingLabel.h"
#import "ZLoadingView.h"

@interface AnimationViewController ()

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    LoadingLabel *loading = [[LoadingLabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40)];
    loading.textColor = [UIColor blueColor];
    [self.view addSubview:loading];
    loading.text = @"loadin...";
    [loading showLoadingView:@[(__bridge id)[[UIColor greenColor] colorWithAlphaComponent:0.3].CGColor,
                               (__bridge id)[UIColor yellowColor].CGColor,
                               (__bridge id)[[UIColor yellowColor] colorWithAlphaComponent:0.3].CGColor]];
    
    ZLoadingView *loadingView = [[ZLoadingView alloc] initWithFrame:CGRectMake(50, 50, 80, 80)];
    loadingView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [loadingView showBlueToothConnecting:self.view];
    [self.view addSubview:loadingView];
    
    ZLoadingView *loadingView1 = [[ZLoadingView alloc] initWithFrame:CGRectMake(50, 150, 80, 80)];
    loadingView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [loadingView1 showLoadingView];
    [loadingView1 showBlueToothConnecting:self.view];
    [self.view addSubview:loadingView1];
    
    ZLoadingView *loadingView3 = [[ZLoadingView alloc] initWithFrame:CGRectMake(50, 250, 80, 80)];
    loadingView3.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [loadingView3 showLoadingView];
    [loadingView3 showSuccess];
    [self.view addSubview:loadingView3];
    
    ZLoadingView *loadingView4 = [[ZLoadingView alloc] initWithFrame:CGRectMake(50, 350, 80, 80)];
    loadingView4.backgroundColor = [UIColor groupTableViewBackgroundColor];
    loadingView4.failColor = [UIColor redColor];
    [loadingView4 showLoadingView];
    [loadingView4 showFailed];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [loadingView4 showEndLoading];
    });
    [self.view addSubview:loadingView4];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
