//
//  ZLoadingView.m
//  MyShow
//
//  Created by jianhua zhang on 2018/4/9.
//  Copyright © 2018年 花落永恒. All rights reserved.
//

#import "ZLoadingView.h"

@interface ZLoadingView()

@property (nonatomic, assign) CGPoint centerPoint;

@property (nonatomic, strong) CAShapeLayer *loadingLayer;

@property (nonatomic, strong) CAShapeLayer *endLoadingLayer;

@property (nonatomic, strong) CAShapeLayer *failLayer;



@end

@implementation ZLoadingView

- (UIColor *)loadingStrokeColor{
    if(_loadingStrokeColor){
        return _loadingStrokeColor;
    }
    return [UIColor blueColor];
}

- (void)showLoadingView{
    _loadingLayer = [CAShapeLayer layer];
    _loadingLayer.lineWidth = loadingLineWidth;
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    CGFloat radius = MIN(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) - _loadingLayer.lineWidth / 2;
    CGFloat startAngle = (CGFloat)(0);
    CGFloat endAngle = (CGFloat)(2*M_PI);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    _loadingLayer.path = path.CGPath;
    _loadingLayer.strokeColor = [UIColor blueColor].CGColor;
    _loadingLayer.fillColor = [UIColor clearColor].CGColor;
    _loadingLayer.strokeStart = 0.f;
    _loadingLayer.strokeEnd = 1.f;
    _loadingLayer.fillMode = kCAFillModeRemoved;
    _loadingLayer.lineDashPattern = @[@1,@3];
    
    /// 起点动画
    CABasicAnimation * strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(-1);
    strokeStartAnimation.toValue = @(1);
    
    /// 终点动画
    CABasicAnimation * strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0.0);
    strokeEndAnimation.toValue = @(1.0);
    
    /// 组合动画
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
    animationGroup.duration = 2.f;
    animationGroup.repeatCount = CGFLOAT_MAX;
    animationGroup.fillMode = kCAFillModeBoth;
    animationGroup.removedOnCompletion = NO;
    [_loadingLayer addAnimation:animationGroup forKey:nil];
    
    [self.layer addSublayer:_loadingLayer];
}
- (void)showEndLoading{
    _endLoadingLayer = [CAShapeLayer layer];
    _endLoadingLayer.lineWidth = loadingLineWidth;
    _endLoadingLayer.fillColor = [UIColor clearColor].CGColor;
    _endLoadingLayer.strokeColor = self.loadingStrokeColor.CGColor;
    
    CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    CGFloat radius = MIN(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) - _endLoadingLayer.lineWidth / 2;
    CGFloat startAngle = (CGFloat)(0);
    CGFloat endAngle = (CGFloat)(2*M_PI);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    _endLoadingLayer.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = loadingDuration;
    animation.repeatCount = 1;
    animation.removedOnCompletion = YES;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    [_endLoadingLayer addAnimation:animation forKey:nil];
    
    [self.layer addSublayer:_endLoadingLayer];
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
- (void)showSuccess{
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.lineWidth = 5.f;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.strokeColor = [UIColor blueColor].CGColor;
    
    shape.strokeStart = 0.f;
    shape.strokeEnd = 1.f;
    
    UIBezierPath *path = [self tickPath];
    shape.path = path.CGPath;
    
    CABasicAnimation * strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0.0);
    strokeEndAnimation.toValue = @(1.0);
    strokeEndAnimation.duration = 1.f;
    strokeEndAnimation.repeatCount = 1;
    strokeEndAnimation.removedOnCompletion = YES;
    [shape addAnimation:strokeEndAnimation forKey:@"success"];
    
    [self.layer addSublayer:shape];
}
- (void)showFailed{
    
    CAShapeLayer *failLayer1 = [CAShapeLayer layer];
    failLayer1.lineWidth = failLineWidth;
    failLayer1.fillColor = self.fillColor.CGColor;
    failLayer1.strokeColor = self.failColor.CGColor;
    
    failLayer1.strokeStart = 0.f;
    failLayer1.strokeEnd = 1.f;
    
    CAShapeLayer *failLayer2 = [CAShapeLayer layer];
    failLayer2.lineWidth = failLineWidth;
    failLayer2.fillColor = self.fillColor.CGColor;
    failLayer2.strokeColor = self.failColor.CGColor;
    
    failLayer2.strokeStart = 0.f;
    failLayer2.strokeEnd = 1.f;
    
    NSArray *pathArr = [self failPath];
    failLayer1.path = [pathArr[0] CGPath];
    failLayer2.path = [pathArr[1] CGPath];
    
    CABasicAnimation * strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0.0);
    strokeEndAnimation.toValue = @(1.0);
    strokeEndAnimation.duration = 1.f;
    strokeEndAnimation.repeatCount = 1;
    strokeEndAnimation.removedOnCompletion = YES;
    [failLayer1 addAnimation:strokeEndAnimation forKey:@"fail"];
    [failLayer2 addAnimation:strokeEndAnimation forKey:@"fail"];
    
    [self.layer addSublayer:failLayer1];
    [self.layer addSublayer:failLayer2];
    
}
//绘制蓝牙路径
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
//绘制勾路径
- (UIBezierPath *)tickPath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat width = 10;
    
    CGPoint p1 = CGPointMake(self.frame.size.width/2 - 3 * width, self.frame.size.width/2);
    CGPoint p2 = CGPointMake(self.frame.size.width/2 - width, self.frame.size.width/2 + 2 * width);
    CGPoint p3 = CGPointMake(self.frame.size.width/2 + 3 * width, self.frame.size.width/2 - 2 * width);
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    [path addLineToPoint:p3];
    
    return path;
}
//绘制X路径
- (NSArray *)failPath{
    UIBezierPath *pathL = [UIBezierPath bezierPath];
    UIBezierPath *pathR = [UIBezierPath bezierPath];
    
    CGPoint p1 = CGPointMake(self.frame.size.width/2 - failWidth, self.frame.size.width/2 - failWidth);
    CGPoint p2 = CGPointMake(self.frame.size.width/2 + failWidth, self.frame.size.width/2 + failWidth);
    CGPoint p3 = CGPointMake(self.frame.size.width/2 + failWidth, self.frame.size.width/2 - failWidth);
    CGPoint p4 = CGPointMake(self.frame.size.width/2 - failWidth, self.frame.size.width/2 + failWidth);
    
    [pathL moveToPoint:p1];
    [pathL addLineToPoint:p2];
    
    [pathR moveToPoint:p3];
    [pathR addLineToPoint:p4];
    
    return @[pathL,pathR];
}
//绘制感叹号路径
- (UIBezierPath *)warningPath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    return path;
}
@end
