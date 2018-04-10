//
//  ZLoadingView.m
//  MyShow
//
//  Created by jianhua zhang on 2018/4/9.
//  Copyright © 2018年 花落永恒. All rights reserved.
//

#import "ZLoadingView.h"

@interface ZLoadingView()

@end

@implementation ZLoadingView

- (void)showLoadingView{
    
}

- (void)showBlueToothConnecting:(UIView *)superView{
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 3;
    
    UIBezierPath *path = [self blueToothPath];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = nil;
    shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 1;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.repeatCount = 1;
    animation.duration = 2.f;
    animation.removedOnCompletion = YES;
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    [shapeLayer addAnimation:animation forKey:nil];
    
    [self.layer addSublayer:shapeLayer];
    
    CAGradientLayer *graLayer = [CAGradientLayer layer];
    graLayer.colors = @[(__bridge id)[UIColor blueColor].CGColor,
                        (__bridge id)[[UIColor blueColor] colorWithAlphaComponent:0.3].CGColor,
                        (__bridge id)[UIColor blueColor].CGColor];
    graLayer.frame = self.bounds;
    //渐变方向起点
    graLayer.startPoint = CGPointMake(0, 0);
    //渐变方向的重点
    graLayer.endPoint = CGPointMake(1, 0);
    //colors中各颜色对应的初始渐变点
    graLayer.locations = @[@(0.0), @(0.0), @(0.1)];
    
    //创建动画
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation1.duration = 2.f;
    animation1.toValue = @[@(0.5), @(1.0), @(1.0)];
    animation1.repeatCount = HUGE_VALF;
    animation1.fillMode = kCAFillModeForwards;
    [graLayer addAnimation:animation1 forKey:@"loadingLabel"];
    
    shapeLayer.mask = graLayer;
    
}
- (UIBezierPath *)blueToothPath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint p1 = CGPointMake(self.frame.size.width/2-blueToothWidth, self.frame.size.height/2-blueToothWidth);
    CGPoint p2 = CGPointMake(self.frame.size.width/2+blueToothWidth, self.frame.size.height/2+blueToothWidth);
    CGPoint p3 = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+blueToothWidth*2);
    CGPoint p4 = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-2*blueToothWidth);
    CGPoint p5 = CGPointMake(self.frame.size.width/2+blueToothWidth, self.frame.size.height/2-blueToothWidth);
    CGPoint p6 = CGPointMake(self.frame.size.width/2-blueToothWidth, self.frame.size.height/2+blueToothWidth);
    
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    [path addLineToPoint:p3];
    [path addLineToPoint:p4];
    [path addLineToPoint:p5];
    [path addLineToPoint:p6];
    
    return path;
}
@end
