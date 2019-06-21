//
//  LookViewController.m
//  NoName
//
//  Created by 划落永恒 on 2019/1/5.
//  Copyright © 2019 com.hualuoyongheng. All rights reserved.
//

#import "LookViewController.h"
#import <UIImage+GIF.h>
#import <Photos/Photos.h>

@interface LookViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation LookViewController
- (IBAction)savePhoto:(id)sender {
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:self.image.image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        [self showAlert:!error];
    }];
}
- (void)showAlert:(BOOL)success{
    NSString *message = @"保存失败";
    if (success) {
        message = @"保存成功";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (UIModalTransitionStyle)modalTransitionStyle{
    return UIModalTransitionStyleCrossDissolve;
}
- (UIModalPresentationStyle)modalPresentationStyle{
    return UIModalPresentationOverFullScreen;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = [NSTemporaryDirectory() stringByAppendingPathComponent:self.str] ;
    NSData *gifData = [NSData dataWithContentsOfFile:str];
    self.image.image = [UIImage sd_animatedGIFWithData:gifData];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
