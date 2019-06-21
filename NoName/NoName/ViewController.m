//
//  ViewController.m
//  NoName
//
//  Created by 划落永恒 on 2018/12/11.
//  Copyright © 2018 com.hualuoyongheng. All rights reserved.
//

#import "ViewController.h"
#import "ZLPhotoActionSheet.h"
#import "ZLPhotoModel.h"

#import "ToolsVideo.h"
#import <UIImage+GIF.h>
#import "GIFGenerator.h"

@interface ViewController ()

@property (nonatomic, strong) ZLPhotoActionSheet *actionSheet;

@property (nonatomic, strong, readonly) ZLPhotoConfiguration *configuration;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *progressbgView;
@property (weak, nonatomic) IBOutlet UILabel *progressLB;
@property (weak, nonatomic) IBOutlet UIView *saveView;
@property (weak, nonatomic) IBOutlet UIButton *holderBtn;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (nonatomic, strong) NSString *preViewPath;

@property (nonatomic, strong) NSArray *imagesArr;
@end

@implementation ViewController

- (IBAction)saveHistory:(id)sender {
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString *ide = [ToolsVideo getLastID];
    NSString *name = [NSString stringWithFormat:@"history%@.gif",ide];
    NSString *str = [NSTemporaryDirectory() stringByAppendingPathComponent:name];
    
    if ([manager copyItemAtPath:_preViewPath toPath:str error:nil]) {
        [self showAlert:[ToolsVideo saveImageid:ide Path:name]];
    }else{
        [self showAlert:NO];
    }
}
- (IBAction)savePhoto:(id)sender {
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:self.gifImageView.image];
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

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)selectImage:(id)sender {
    self.actionSheet.configuration.allowSelectVideo = NO;
    self.actionSheet.configuration.allowSelectImage = YES;
    [self.actionSheet showPhotoLibrary];
}
- (IBAction)selectVideo:(id)sender {
    self.actionSheet.configuration.allowSelectVideo = YES;
    self.actionSheet.configuration.allowSelectImage = NO;
    [self.actionSheet showPhotoLibrary];
}

- (ZLPhotoActionSheet *)actionSheet{
    if (!_actionSheet) {
        _actionSheet = [[ZLPhotoActionSheet alloc] init];
        _actionSheet.configuration.navBarColor = [UIColor colorForMainColor];
    }
    _actionSheet.sender = self;
    __weak typeof(self)weakSelf = self;
    _actionSheet.selectImageBlock = ^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        [weakSelf type:images assets:assets];
    };
    return _actionSheet;
}
- (void)showProgress:(CGFloat)progress{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(progress >= 1){
            self.progressbgView.hidden = YES;
            self.saveView.hidden = NO;
        }else if(progress <= 0){
            self.progressbgView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
            self.saveView.hidden = YES;
        }else{
            self.progressbgView.hidden = NO;
        }
        [self.progressView setProgress:progress animated:YES];
        self.progressLB.text = [NSString stringWithFormat:@"%.2f%%",progress * 100];
    });
}
- (IBAction)chang:(UISlider *)sender forEvent:(UIEvent *)event {
    self.timeLB.text = [NSString stringWithFormat:@"间隔时间:%.2f",sender.value];
    UITouch *touch = [[event.allTouches allObjects] firstObject];
    if (touch.phase == UITouchPhaseEnded) {
        NSLog(@"%@",event);
        [self showProgress:0];
        [self loadGIF:[ToolsVideo exportGifImages:self.imagesArr delays:@[[NSNumber numberWithFloat:sender.value]] loopCount:0 progressBlock:^(CGFloat progress) {
            [self showProgress:progress];
        }]];
    }
}

- (void)type:(NSArray<UIImage *> *)images assets:(NSArray<PHAsset *>*)assets{
    PHAsset *ass = (PHAsset *)[assets firstObject];
    __weak typeof(self)weakSelf = self;
    self.gifImageView.image = nil;
    [self showProgress:0];
    self.holderBtn.hidden = images.count!=0 || assets.count != 0;
    self.imagesArr = images;
    self.sliderView.hidden = YES;
    self.timeLB.hidden = YES;
    
    if (ass.mediaType == PHAssetMediaTypeImage) {
       
        [self loadGIF:[ToolsVideo exportGifImages:images delays:nil loopCount:0 progressBlock:^(CGFloat progress) {
            [self showProgress:progress];
        }]];
    }else if(ass.mediaType == PHAssetMediaTypeVideo){
        
        [[PHImageManager defaultManager] requestAVAssetForVideo:ass options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            
            NSString *movieLocalPath = [NSString stringWithFormat:@"%@.gif",@"preview1"];
            NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:movieLocalPath];
            [GIFGenerator shareGIFGenerator].progressBlock = ^(CGFloat process) {
                [self showProgress:process];
            };
            [GIFGenerator shareGIFGenerator].endBlock = ^(BOOL status, NSError * _Nonnull error) {
                if (status) {
                    [self showProgress:1];
                    [weakSelf loadGIF:filePath];
                }
            };
            [[GIFGenerator shareGIFGenerator] createGIFfromURL:[(AVURLAsset *)asset URL] loopCount:0 startSecond:0 delayTime:0.1 gifTime:ass.duration gifImagePath:filePath];
        }];
    }else{
        NSLog(@"错误");
    }
}
- (void)loadGIF:(NSString *)path{
    self.preViewPath = path;
    
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    if ([NSThread currentThread] == [NSThread mainThread]) {
        self.gifImageView.image= [UIImage sd_animatedGIFWithData:gifData];
        self.saveView.hidden = !path;
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.gifImageView.image= [UIImage sd_animatedGIFWithData:gifData];
            self.saveView.hidden = !path;
        });
    }
}

@end
