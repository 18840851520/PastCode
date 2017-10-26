//
//  TurntableView.m
//  MyShow
//
//  Created by 花落永恒 on 2017/10/24.
//  Copyright © 2017年 花落永恒. All rights reserved.
//

#import "TurntableView.h"

@implementation TurntableView

//开始旋转转盘
- (void)startRotate{
    //旋转180°
//    int i = 5;
//    do {
//        CGAffineTransform transform;
//        //旋转度数
//        transform = CGAffineTransformRotate(self.transform, 1 * M_PI);
//        //动画开始
//        [UIView beginAnimations:@"rotate" context:nil];
//        //动画时长
//        [UIView setAnimationDuration:1];
//        //添加代理
//        [UIView setAnimationDelegate:self];
//        //获取Transform的值
//        [self setTransform:transform];
//
//        [UIView commitAnimations];
//
//        i --;
//    } while (i);
    
    CABasicAnimation* rotationAnimation;
    
    //随机数 除以个数取余，获得中奖区间
    _index = arc4random() % self.titles.count / (float)self.titles.count;
    float section = 1.f / self.titles.count;
    float value = _index + (arc4random() % 9 + 1) * section / 10;
    
    NSLog(@"%@",[NSNumber numberWithFloat:value]);
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.f * (4 + value)];
    rotationAnimation.duration = 2.0;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.delegate = self;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
//    CABasicAnimation* rotationAnimation1;
//    rotationAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//
//    //随机数 除以个数取余，获得中奖区间
//    float index = arc4random() % self.titles.count / (float)self.titles.count;
//
//
//    rotationAnimation1.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * index];
//    rotationAnimation1.duration = 2.0;
//    rotationAnimation1.cumulative = YES;
//    //    rotationAnimation.repeatCount = 1.0;
//    rotationAnimation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//
//    [self.layer addAnimation:rotationAnimation1 forKey:@"rotationAnimation"];
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
//    CGAffineTransform transform = self.transform;
//    CGFloat rotate = acosf(transform.a);
//    if (transform.b < 0) {
//        rotate+= M_PI;
//    }
//    CGFloat degree = rotate/M_PI * 180;
//    NSLog(@"+++++++++ degree : %f", degree);
//
//    NSLog(@"%@",[NSNumber numberWithFloat:rotate].stringValue);
    
    NSLog(@"%@ %@",[NSNumber numberWithFloat:self.titles.count - _index * self.titles.count].stringValue,self.titles[self.titles.count - [NSNumber numberWithFloat:_index * self.titles.count].integerValue - 1]);    
    if (flag) {
        if ([self.delegate respondsToSelector:@selector(rotationDidEnd:)]) {
            [self.delegate rotationDidEnd:[NSNumber numberWithInteger:self.titles.count - [NSNumber numberWithFloat:_index * self.titles.count].integerValue - 1].stringValue];
        }
    }
}
- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    [self setNeedsDisplay];
}
- (void)setTurntablePointerStyle:(TurntablePointer)turntablePointerStyle{
    _turntablePointerStyle = turntablePointerStyle;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    
//    for (int i = 0; i < self.titles.count; i ++) {
//        UIBezierPath *linePath = [UIBezierPath bezierPath];
//        [linePath addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.width/2 - 1 startAngle:(float)i / (float)self.titles.count * 2 * M_PI endAngle:(float)(i+1) / (float)self.titles.count * 2 * M_PI clockwise:YES];
//        float index = arc4random();
//        float index1 = index + arc4random();
//        [[UIColor colorWithRed:index/index1 green:index/index1 blue:index/index1 alpha:1] set];
//        [linePath fill];
//    }
    
    float beginningAngle;
    if (self.turntablePointerStyle == TurntablePointerTop) {
        beginningAngle = 3.f / 2.f * M_PI;
    }else if (self.turntablePointerStyle == TurntablePointerLeft) {
        beginningAngle = M_PI;
    }else if (self.turntablePointerStyle == TurntablePointerBottom) {
        beginningAngle = M_PI_2;
    }else{
        beginningAngle = 0;
    }
    
    float averageAngle = 1 / (float)self.titles.count * 2 * M_PI;
    float startAngle = 0;
    for (int i = 0; i < self.titles.count; i ++) {
        UIBezierPath *linePath = [UIBezierPath bezierPath];

        startAngle = beginningAngle + (float)i / (float)self.titles.count * 2 * M_PI;
        [linePath moveToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        [linePath addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.width/2 - 1 startAngle:startAngle endAngle:startAngle + averageAngle  clockwise:YES];
        
        NSInteger index = arc4random() % 255;
        float red = (arc4random() - index) / 255.f;
        float green = arc4random_uniform(255) / 255.f;
        float blue = arc4random_uniform(255) / 255.f;
        [[UIColor colorWithRed:red green:green blue:blue alpha:1] set];
        [linePath fill];
        
//        [linePath moveToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
//        [linePath addLineToPoint:[self calcCircleCoordinateWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) angle:(float)i / (float)self.titles.count * 360.f  radius:self.frame.size.width/2 - 1]];
//        [[UIColor whiteColor] set];
//        [linePath stroke];
    }
    
    
//    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.width/2 - 1 startAngle:0 endAngle:2 * M_PI clockwise:YES];
//    [[UIColor redColor] set];
//    [bgPath fill];
//
//    for (int i = 0; i < self.titles.count; i ++) {
//        UIBezierPath *linePath = [UIBezierPath bezierPath];
//        [linePath moveToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
//        [linePath addLineToPoint:[self calcCircleCoordinateWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) angle:(float)i / (float)self.titles.count * 360.f  radius:self.frame.size.width/2 - 1]];
//        [[UIColor whiteColor] set];
//        [linePath stroke];
//    }
}
#pragma mark 计算圆圈上点在IOS系统中的坐标
- (CGPoint)calcCircleCoordinateWithCenter:(CGPoint)center angle:(CGFloat)angle radius:(CGFloat)radius
{
    CGFloat x2 = radius * cosf(angle * M_PI / 180);
    CGFloat y2 = radius * sinf(angle * M_PI / 180);
    return CGPointMake(center.x + x2, center.y - y2);
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
}
@end
