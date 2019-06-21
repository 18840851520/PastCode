//
//  ZJHAlertViewController.m
//  MyShow
//
//  Created by jianhua zhang on 2018/3/27.
//  Copyright © 2018年 花落永恒. All rights reserved.
//

#import "ZJHAlertViewController.h"

@interface ZJHAlertViewController ()

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *cancelButtonTitle;
@property (strong, nonatomic) NSArray *otherButtonTitles;
@property (strong, nonatomic) NSMutableArray *otherButtons;

@end

@implementation ZJHAlertViewController

- (UIModalPresentationStyle)modalPresentationStyle{
    return UIModalPresentationOverFullScreen;
}
- (UIModalTransitionStyle)modalTransitionStyle{
    return UIModalTransitionStyleCrossDissolve;
}
- (instancetype)initWithAlertStyle:(ZJHAlertStyle)alertStyle Title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles clickBlock:(ZJHAlertBlock)selectBlock{
    self = [super init];
    if (self) {
        self.title = title;
        self.message = message;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitles = otherButtonTitles;
        self.zAlertStyle = alertStyle;
        self.selectBlock = selectBlock;
    }
    return self;
}
- (void)alertShowWithStyle:(ZJHAlertShowStyle)alertStyle{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
