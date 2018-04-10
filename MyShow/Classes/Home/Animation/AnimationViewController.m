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
