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
    
    [self.blueTools connectBlueToothWithMACAdress:@"78a50457f38b"];
}
- (void)blueToothConnectDeviceStated:(BlueToothState)state{
    if(state == BlueToothStateNotify){
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
