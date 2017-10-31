//
//  JHHomeViewController.m
//  MyShow
//
//  Created by 花落永恒 on 2017/10/24.
//  Copyright © 2017年 花落永恒. All rights reserved.
//

#import "JHHomeViewController.h"
#import "TurntableViewController.h"

@interface JHHomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *classNames;

@end

@implementation JHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[@"转盘"];
    self.classNames = @[@"TurntableViewController"];
}
#pragma mark delegate & datasource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className = self.classNames[indexPath.row];
    
    // 注意: 如果是sb来搭建, 必须以 _UIStoryboard 结尾
    NSUInteger classNameLength = className.length;
    NSUInteger storyBoardLength = @"_UIStoryboard".length;
    NSUInteger xibLength = @"_xib".length;
    
    NSString *suffixClassName;
    if (classNameLength > storyBoardLength) {
        suffixClassName = [className substringFromIndex:classNameLength - storyBoardLength];
    }
    
    if ([suffixClassName isEqualToString:@"_UIStoryboard"]) {
        
        className = [className substringToIndex:classNameLength - storyBoardLength];
        
        if ([className isEqualToString:@"RZSimpleViewController"]) {  // 自定义push动画

        }else {
            
            // 注意: 这个storyboard的名字必须是控制器的名字
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:className bundle:nil];
            UIViewController *cardVC = [storyBoard instantiateInitialViewController];
            if (!cardVC) {
                cardVC = [storyBoard instantiateViewControllerWithIdentifier:className];
            }
            cardVC.title = self.titles[indexPath.row];
            [self.navigationController pushViewController:cardVC animated:YES ];
        }
        
    }else if ([[className substringFromIndex:classNameLength - xibLength] isEqualToString:@"_xib"]) {
        
        className = [className substringToIndex:classNameLength - xibLength];
        
        UIViewController *vc = [[NSClassFromString(className) alloc]initWithNibName:className bundle:nil];
        vc.title = self.titles[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        NSLog(@"className = %@", className);
        UIViewController *vc = [[NSClassFromString(className) alloc] init];
        vc.title = self.titles[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
