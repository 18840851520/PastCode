//
//  TurntableViewController.m
//  MyShow
//
//  Created by 花落永恒 on 2017/10/24.
//  Copyright © 2017年 花落永恒. All rights reserved.
//

#import "TurntableViewController.h"
#import "TurntableView.h"

@interface TurntableViewController ()<TurntableViewDelegate>

@property (weak, nonatomic) IBOutlet TurntableView *turntableView;
@property (weak, nonatomic) IBOutlet UILabel *lotteryLB;
@property (weak, nonatomic) IBOutlet UITextField *titlesTF;
@property (nonatomic, strong) NSMutableArray *titlesArray;

@end

@implementation TurntableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    @[@"好吃不如饺子",@"乐速",@"沙县小吃",@"筒骨饭",@"牛肉粉",@"肉蟹煲",@"撸串",@"烧烤",@"火锅",@"一点点"]
    self.titlesArray = [NSMutableArray arrayWithArray:@[@"撸串",@"烧烤",@"自助烧烤",@"自助火锅",@"麻辣香锅",@"熔鱼"]];
    self.titlesTF.text = [self.titlesArray componentsJoinedByString:@","];
    self.turntableView.titles = self.titlesArray.mutableCopy;
    self.turntableView.turntablePointerStyle = TurntablePointerTop;
    self.turntableView.delegate = self;
}
- (IBAction)changeAction:(UITextField *)sender {
    NSString *str = sender.text;
    NSRange range = [str rangeOfString:@"，"];
    if (range.location != NSNotFound) {
        sender.text = [str stringByReplacingOccurrencesOfString:@"，" withString:@","];
    }
    self.titlesArray = [NSMutableArray arrayWithArray:[sender.text componentsSeparatedByString:@","]];
    self.turntableView.titles = self.titlesArray.mutableCopy;
}
- (IBAction)startRotateAction:(id)sender {
}
- (void)rotationDidEnd:(NSString *)index{
    self.lotteryLB.text = [self.turntableView.titles objectAtIndex:index.integerValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
