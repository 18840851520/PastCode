//
//  GIFGenerator.h
//  NoName
//
//  Created by 划落永恒 on 2019/1/2.
//  Copyright © 2019 com.hualuoyongheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface GIFGenerator : NSObject

@property (nonatomic, copy) void (^endBlock)(BOOL status,NSError *error);
@property (nonatomic, copy) void (^progressBlock)(CGFloat process);
@property (nonatomic, assign) CGFloat second;

+(instancetype)shareGIFGenerator;

- (void)generatorGIFWithLocalVideoPath:(NSString *)strVideoPath startSecond:(float)startSecond gifTime:(float)gifTime gifFilePath:(NSString *)gifFilePath completeBlock:(void(^)(BOOL isSuccess,NSError *error))completeBlock;

- (void)createGIFfromURL:(NSURL*)videoURL loopCount:(int)loopCount startSecond:(float)fltStartSecond delayTime:(CGFloat)delayTime gifTime:(float)fltGifTime gifImagePath:(NSString *)imagePath;

@end

NS_ASSUME_NONNULL_END
