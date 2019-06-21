//
//  ToolsVideo.h
//  MyLearn
//
//  Created by 划落永恒 on 2018/12/6.
//  Copyright © 2018 jianhua zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^ToolsDecompositionCompleteBlock)(BOOL isSuccess,id decompositionImgs);
typedef void(^ToolsProgressBlock)(CGFloat progress);

@interface ToolsVideo : NSObject

+ (NSArray *)getImageArray;

+ (BOOL)delImagePath:(NSString *)ide;

+ (BOOL)saveImageid:(NSString *)ide Path:(NSString *)path;

+ (NSString *)getLastID;
/**
 *@brief 分解视频
 *@param    fileUrl 视频理解    fps 帧率     progress 执行进度   complete 完成回调
 */
+ (void)decompositionWithVideoPath:(NSURL *)fileUrl
                            andFps:(int32_t)fps
                     progressBlock:(ToolsProgressBlock)progress
        decompositionCompleteBlock:(ToolsDecompositionCompleteBlock)complete;
/**
 *@brief 图片合成视频
 *@param    imagesArr 图片数组    fps 帧率     progress 执行进度   complete 完成回调
 */
+ (void)syntheticVideoWithImage:(NSArray<UIImage *>*)imagesArr
                         andFPS:(int32_t)fps
                  progressBlock:(ToolsProgressBlock)progress
     decompositionCompleteBlock:(ToolsDecompositionCompleteBlock)complete;
/**
 *@brief 图片合成动图
 *@param    images 图片数组    delays 延迟    loopCount 重复次数
 */
+ (NSString *)exportGifImages:(NSArray*)images
                      delays:(NSArray*)delays
                   loopCount:(NSUInteger)loopCount
                progressBlock:(ToolsProgressBlock)progress;
/**
 *@brief 视频转成动图
 *@param    fileUrl 视频路径    delays 延迟    loopCount 重复次数
 */
+ (NSString *)exportGifVideoPath:(NSURL *)fileUrl
                      delays:(NSArray*)delays
                   loopCount:(NSUInteger)loopCount;
/**
 *@brief 视频预览图
 *@param    fileUrl 视频路径
 */
+ (UIImage*)getVideoPreViewImage:(NSURL *)fileUrl;


@end

NS_ASSUME_NONNULL_END
