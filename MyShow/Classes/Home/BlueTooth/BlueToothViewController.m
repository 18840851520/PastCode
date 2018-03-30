//
//  BlueToothViewController.m
//  MyShow
//
//  Created by jianhua zhang on 2018/3/30.
//  Copyright © 2018年 花落永恒. All rights reserved.
//

#import "BlueToothViewController.h"
#import "ZBlueToothTools.h"

@interface BlueToothViewController ()<ZBlueToothToolsDelegate>

@property (nonatomic, strong) ZBlueToothTools *blueTools;

@end

@implementation BlueToothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.blueTools = [[ZBlueToothTools alloc] init];
    self.blueTools.delegate = self;
    
    //连接mac地址为 78a50457f38b|| 78:a5:04:57:f3:8b 蓝牙
    [self.blueTools connectBlueToothWithMACAdress:@"78a50457f38b"];
}
- (void)blueToothConnectDeviceStated:(BlueToothState)state{
    if(state == BlueToothStateNotify){
        //获取蓝牙特征值后发送指令
        [self.blueTools sendValue:@"a1b10203ec000402010100010106" AndBlock:nil];
    }
}
- (void)blueToothWriteStatus:(BOOL)isSuccess{
    NSLog(@"writeIsSuccess=%d",isSuccess);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
