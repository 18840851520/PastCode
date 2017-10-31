//
//  TurntableView.m
//  MyShow
//
//  Created by 花落永恒 on 2017/10/24.
//  Copyright © 2017年 花落永恒. All rights reserved.
//

#import "TurntableView.h"

//动画持续时间
static NSInteger animationDuration = 3.0;
//旋转的半圈 数
static NSInteger circle = 6;

@implementation TurntableView

//开始旋转转盘
- (void)startRotate{

    self.userInteractionEnabled = NO;
    
    CABasicAnimation* rotationAnimation;
    //随机数 除以个数取余，获得中奖区间
    _index = arc4random() % self.titles.count / (float)self.titles.count;
    float section = 1.f / self.titles.count;
    float value = _index + (arc4random() % 9 + 1) * section / 10;
    
    NSLog(@"%@",[NSNumber numberWithFloat:value]);
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.f * (circle * 2 + value)];
    rotationAnimation.duration = animationDuration;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.delegate = self;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
#pragma mark 动画停止
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    self.userInteractionEnabled = YES;
    
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
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    //开始角度
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
    //平均角度
    float averageAngle = 1 / (float)self.titles.count * 2 * M_PI;
    float startAngle = 0;
    //半径
    float radius = self.frame.size.width / 2 - 1;
    //创建扇形区域
    for (int i = 0; i < self.titles.count; i ++) {
        UIBezierPath *linePath = [UIBezierPath bezierPath];

        startAngle = beginningAngle + (float)i / (float)self.titles.count * 2 * M_PI;
        [linePath moveToPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        [linePath addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:radius startAngle:startAngle endAngle:startAngle + averageAngle  clockwise:YES];
        
        NSInteger index = arc4random() % 255;
        float red = (arc4random() - index) / 255.f;
        float green = arc4random_uniform(255) / 255.f;
        float blue = arc4random_uniform(255) / 255.f;
        [[UIColor colorWithRed:red green:green blue:blue alpha:1] set];
        [linePath fill];
        
        [[UIColor whiteColor] set];
        [linePath stroke];
        
        NSString *title = [self.titles objectAtIndex:i];
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(radius * (cos(startAngle + averageAngle / 2.f) + 1), radius * (sin(startAngle + averageAngle / 2.f) + 1), 15, radius)];
        titleLB.text = title;
        titleLB.numberOfLines = 0;
        titleLB.backgroundColor = [UIColor clearColor];
        titleLB.textColor = [UIColor whiteColor];
        titleLB.layer.anchorPoint = CGPointMake(0.5, 1);
        titleLB.layer.position = CGPointMake(radius + 1, radius + 1);
        titleLB.textAlignment = NSTextAlignmentCenter;
        titleLB.adjustsFontSizeToFitWidth = YES;
        titleLB.transform = CGAffineTransformMakeRotation(averageAngle / 2.f + i * averageAngle);
        [self addSubview:titleLB];
        
        
    }
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startRotate)];
    [self addGestureRecognizer:tap];
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
