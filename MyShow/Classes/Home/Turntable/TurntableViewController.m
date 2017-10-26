//
//  TurntableViewController.m
//  MyShow
//
//  Created by 花落永恒 on 2017/10/24.
//  Copyright © 2017年 花落永恒. All rights reserved.
//

#import "TurntableViewController.h"
#import "TurntableView.h"

@interface TurntableViewController ()

@property (weak, nonatomic) IBOutlet TurntableView *turntableView;

@end

@implementation TurntableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    @[@"好吃不如饺子",@"乐速",@"沙县小吃",@"筒骨饭",@"牛肉粉",@"肉蟹煲",@"撸串",@"烧烤",@"火锅",@"一点点"]
    self.turntableView.titles = @[@"好吃不如饺子",@"乐速",@"沙县小吃",@"筒骨饭",@"牛肉粉",@"肉蟹煲",@"撸串",@"烧烤",@"火锅",@"一点点"];
    self.turntableView.turntablePointerStyle = TurntablePointerLeft;
}
- (IBAction)startRotateAction:(id)sender {
    [self.turntableView startRotate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
