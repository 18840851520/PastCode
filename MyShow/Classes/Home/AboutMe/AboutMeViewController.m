//
//  AboutMeViewController.m
//  MyShow
//
//  Created by jianhua zhang on 2018/2/23.
//  Copyright © 2018年 花落永恒. All rights reserved.
//

#import "AboutMeViewController.h"
#import "Zhangjh.h"

@interface AboutMeViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) Zhangjh *mySelf;

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mySelf.name = @"张剑华";
    _mySelf.gender = @"男";
    _mySelf.workExperience = @"2015.7-2018年";
    _mySelf.birthday = @"1993-6-25";
    _mySelf.mobile = @"18557517018";
    _mySelf.E_mail = @"zhangjianhua0625@163.com";
    _mySelf.adress = @"杭州-西湖区";
    _mySelf.censusRegister = @"福建-莆田";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
