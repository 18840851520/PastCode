//
//  UIColor+Define.h
//  NoName
//
//  Created by 划落永恒 on 2018/12/11.
//  Copyright © 2018 com.hualuoyongheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Define)

//生成颜色图片
+ (UIImage *)buttonImageFromColor:(UIColor *)color;
//主色调
+ (UIColor *)colorForMainColor;


@end

NS_ASSUME_NONNULL_END
