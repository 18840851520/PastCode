//
//  TurntableView.h
//  MyShow
//
//  Created by 花落永恒 on 2017/10/24.
//  Copyright © 2017年 花落永恒. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TurntablePointerRight,//default.指针在右
    TurntablePointerTop,
    TurntablePointerLeft,
    TurntablePointerBottom
} TurntablePointer;

@protocol TurntableViewDelegate<NSObject>

- (void)rotationDidEnd:(NSString *)index;//选中区域

@end

@interface TurntableView : UIView<CAAnimationDelegate>

//所有的描述
@property (nonatomic, strong) NSArray *titles;
//指针位置
@property (nonatomic, assign) TurntablePointer turntablePointerStyle;

@property (nonatomic, strong) id<TurntableViewDelegate> delegate;

@property (nonatomic, assign) float index;

//开始旋转转盘
- (void)startRotate;

@end
