//
//  LoadingLabel.m
//  MyShow
//
//  Created by jianhua zhang on 2018/4/8.
//  Copyright © 2018年 花落永恒. All rights reserved.
//

#import "LoadingLabel.h"

@interface LoadingLabel()

@property (nonatomic, strong) NSTimer *loadingAnimationTimer;

@end

@implementation LoadingLabel

//当前开始变化的文字
static int currentIndex = 0;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.amplificationLength = 1;
        self.maxAmplificationFont = 25;
        self.maxLeftAmplificationFont = self.maxRightlificationFont = 20;
        self.minFont = [UIFont systemFontOfSize:15];
        currentIndex = 0;
    }
    return self;
}
- (void)showLoadingView:(NSArray *)cgColor{
    CAGradientLayer *graLayer = [CAGradientLayer layer];
    graLayer.frame = self.bounds;
    graLayer.colors = cgColor;
    //渐变方向起点
    graLayer.startPoint = CGPointMake(0, 0);
    //渐变方向的重点
    graLayer.endPoint = CGPointMake(1, 0);
    //colors中各颜色对应的初始渐变点
    graLayer.locations = @[@(0.0), @(0.0), @(0.1)];
    
    self.loadingAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(loadingTextFontChange) userInfo:nil repeats:YES];
    //创建动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.duration = 2.f;
    animation.toValue = @[@(0.9), @(1.0), @(1.0)];
    animation.removedOnCompletion = NO;
    animation.repeatCount = HUGE_VALF;
    animation.fillMode = kCAFillModeForwards;
    [graLayer addAnimation:animation forKey:@"loadingLabel"];
    
    // 将graLayer设置成textLabel的遮罩
    self.layer.mask = graLayer;
}
- (void)setIsRunning:(BOOL)isRunning{
    _isRunning = isRunning;
    if(self.loadingAnimationTimer){
        [self.loadingAnimationTimer invalidate];
        [self.mutableAttText addAttribute:NSFontAttributeName value:self.minFont range:NSMakeRange(0, self.text.length)];
    }
}
- (void)loadingTextFontChange{
    if(self.text.length == 0){
        return;
    }
    if(!self.mutableAttText){
        self.mutableAttText = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    [self.mutableAttText addAttribute:NSFontAttributeName value:self.minFont range:NSMakeRange(0, self.text.length)];
//    NSLog(@"current = %d,%ld,%f",currentIndex,self.amplificationLength,self.font.pointSize);
    if(currentIndex == 0){
        [self.mutableAttText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.maxRightlificationFont] range:NSMakeRange(currentIndex, self.amplificationLength)];
    }else if(currentIndex == 1){
        if(self.text.length == 1){
            [self.mutableAttText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.maxAmplificationFont] range:NSMakeRange(currentIndex-1, self.amplificationLength)];
        }else{
            [self.mutableAttText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.maxAmplificationFont] range:NSMakeRange(currentIndex-1, self.amplificationLength)];
            [self.mutableAttText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.maxRightlificationFont] range:NSMakeRange(currentIndex, self.amplificationLength)];
        }
    }else if(currentIndex == self.text.length){
        [self.mutableAttText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.maxLeftAmplificationFont] range:NSMakeRange(currentIndex-2, self.amplificationLength)];
        [self.mutableAttText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.maxAmplificationFont] range:NSMakeRange(currentIndex-1, self.amplificationLength)];
    }
//    else if(currentIndex == self.text.length+1 && self.text.length >= 2){
//        [self.mutableAttText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.maxLeftAmplificationFont] range:NSMakeRange(currentIndex-2, self.amplificationLength)];
//    }
    else{
        [self.mutableAttText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.maxLeftAmplificationFont] range:NSMakeRange(currentIndex-2, self.amplificationLength)];
        [self.mutableAttText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.maxAmplificationFont] range:NSMakeRange(currentIndex-1, self.amplificationLength)];
        [self.mutableAttText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.maxRightlificationFont] range:NSMakeRange(currentIndex, self.amplificationLength)];
    }
    currentIndex++;
    if(currentIndex > self.text.length){
        currentIndex = 1;
    }
    self.attributedText = self.mutableAttText;
}
- (void)removeFromSuperview{
    if(self.loadingAnimationTimer){
        [self.loadingAnimationTimer invalidate];
    }
}
- (void)dealloc{
    if(self.loadingAnimationTimer){
        [self.loadingAnimationTimer invalidate];
    }
}

@end
