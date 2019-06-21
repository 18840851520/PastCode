//
//  GIFGenerator.m
//  NoName
//
//  Created by 划落永恒 on 2019/1/2.
//  Copyright © 2019 com.hualuoyongheng. All rights reserved.
//

#import "GIFGenerator.h"
#import <AVKit/AVKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

//typedef NS_ENUM(NSInteger, GIFSize) { GIFSizeVeryLow = 2, GIFSizeLow = 3, GIFSizeMedium = 5, GIFSizeHigh = 7, GIFSizeOriginal = 10 };

typedef NS_ENUM(NSInteger, GIFSize) { GIFSizeVeryLow = 1, GIFSizeLow = 2, GIFSizeMedium = 3, GIFSizeHigh = 5, GIFSizeOriginal = 10 };

//动画1s多少帧
#define kFrameInSecond (24)


@interface GIFGenerator()

@property (nonatomic,strong)NSError *error;

@end
@implementation GIFGenerator

+(instancetype)shareGIFGenerator{
    static GIFGenerator *generator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        generator = [[self alloc] init];
    });
    return generator;
}


- (void)generatorGIFWithLocalVideoPath:(NSString *)strVideoPath startSecond:(float)startSecond gifTime:(float)gifTime gifFilePath:(NSString *)gifFilePath completeBlock:(void(^)(BOOL isSuccess,NSError *error))completeBlock{
    self.error = nil;
    if(![[NSFileManager defaultManager] fileExistsAtPath:strVideoPath]){
        if(completeBlock){
            completeBlock(NO,[[NSError alloc] initWithDomain:NSURLErrorDomain code:-1 userInfo:@{@"msg":@"文件不存在"}]);
        }
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *videoUrl = [NSURL fileURLWithPath:strVideoPath];
        CGFloat delayTime = 1.f / kFrameInSecond;
        [self createGIFfromURL:videoUrl loopCount:1 startSecond:startSecond delayTime:delayTime gifTime:gifTime gifImagePath:gifFilePath];
        
        if(completeBlock){
            dispatch_async(dispatch_get_main_queue(), ^{
                completeBlock(!self.error,self.error);
            });
        }
    });
    
}
- (void)createGIFfromURL:(NSURL*)videoURL loopCount:(int)loopCount startSecond:(float)fltStartSecond delayTime:(CGFloat)delayTime gifTime:(float)fltGifTime gifImagePath:(NSString *)imagePath{
    
    NSDictionary *fileProperties = [self filePropertiesWithLoopCount:loopCount];
    NSDictionary *frameProperties = [self framePropertiesWithDelayTime:delayTime];
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoURL];
    
    float videoWidth = [[[asset tracksWithMediaType:AVMediaTypeVideo] firstObject] naturalSize].width;
    float videoHeight = [[[asset tracksWithMediaType:AVMediaTypeVideo] firstObject] naturalSize].height;
    
    GIFSize optimalSize = GIFSizeMedium;
    if (videoWidth >= 1200 || videoHeight >= 1200)
        optimalSize = GIFSizeVeryLow;
    else if (videoWidth >= 800 || videoHeight >= 800)
        optimalSize = GIFSizeLow;
    else if (videoWidth >= 400 || videoHeight >= 400)
        optimalSize = GIFSizeMedium;
    else if (videoWidth < 400|| videoHeight < 400)
        optimalSize = GIFSizeHigh;
    
    
    int frameCount = fltGifTime * kFrameInSecond;
    
    //两帧的时间间隔
    float increment = (float)fltGifTime/frameCount;
    
    // Add frames to the buffer
    NSMutableArray *timePoints = [NSMutableArray array];
    for (int currentFrame = 0; currentFrame<frameCount; ++currentFrame) {
        float seconds = fltStartSecond + (float)increment * currentFrame;
        CMTime time = CMTimeMakeWithSeconds(seconds, 1 *NSEC_PER_SEC);
        [timePoints addObject:[NSValue valueWithCMTime:time]];
    }
    
    [self createGIFforTimePoints:timePoints fromURL:videoURL fileProperties:fileProperties frameProperties:frameProperties gifImagePath:imagePath frameCount:frameCount gifSize:optimalSize];
}


- (NSURL *)createGIFforTimePoints:(NSArray *)timePoints fromURL:(NSURL *)url fileProperties:(NSDictionary *)fileProperties  frameProperties:(NSDictionary *)frameProperties gifImagePath:(NSString *)imagePath frameCount:(int)frameCount gifSize:(GIFSize)gifSize{
    
    NSURL *fileURL = [NSURL fileURLWithPath:imagePath];
    if (fileURL == nil)
        return nil;
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF , frameCount, NULL);
    CGImageDestinationSetProperties(destination, (CFDictionaryRef)fileProperties);
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    
    NSError *error = nil;
    CGImageRef previousImageRefCopy = nil;
    CGImageRef imageRef;
    NSLog(@"start");
    
    
    CGFloat process = 0;
    for (NSValue *time in timePoints) {
        if (self.progressBlock) {
            self.progressBlock(process/timePoints.count);
        }
        process++;
        imageRef = [generator copyCGImageAtTime:[time CMTimeValue] actualTime:nil error:&error];
        if((float)gifSize/10 != 1){
            imageRef = createImageWithScale(imageRef, (float)gifSize/10);
        }
        
        if (error) {
            _error =error;
            NSLog(@"Error copying image: %@", error);
            return nil;
        }
        if (imageRef) {
            CGImageRelease(previousImageRefCopy);
            previousImageRefCopy = CGImageCreateCopy(imageRef);
        } else if (previousImageRefCopy) {
            imageRef = CGImageCreateCopy(previousImageRefCopy);
        } else {
            _error =[NSError errorWithDomain:NSStringFromClass([self class]) code:0 userInfo:@{NSLocalizedDescriptionKey:@"Error copying image and no previous frames to duplicate"}];
            NSLog(@"Error copying image and no previous frames to duplicate");
            return nil;
        }
        CGImageDestinationAddImage(destination, imageRef, (CFDictionaryRef)frameProperties);
        CGImageRelease(imageRef);
    }
    NSLog(@"end");
    CGImageRelease(previousImageRefCopy);
    // Finalize the GIF
    if (!CGImageDestinationFinalize(destination)) {
        _error =error;
        NSLog(@"Failed to finalize GIF destination: %@", error);
        if (destination != nil) {
            CFRelease(destination);
        }
        return nil;
    }
    CFRelease(destination);
    if (self.endBlock) {
        self.endBlock(!_error, _error);
    }
    return fileURL;
}

#pragma mark - Helpers

CGImageRef createImageWithScale(CGImageRef imageRef, float scale) {
    
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    CGSize newSize = CGSizeMake(CGImageGetWidth(imageRef)*scale, CGImageGetHeight(imageRef)*scale);
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        return nil;
    }
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    //Release old image
    CFRelease(imageRef);
    // Get the resized image from the context and a UIImage
    imageRef = CGBitmapContextCreateImage(context);
    
    UIGraphicsEndImageContext();
#endif
    
    return imageRef;
}

#pragma mark - Properties

- (NSDictionary *)filePropertiesWithLoopCount:(int)loopCount {
    //GIF播放
    //0不循环 1无限循环
    return @{(NSString *)kCGImagePropertyGIFDictionary:
                 @{(NSString *)kCGImagePropertyGIFLoopCount: @(loopCount)}
             };
}

- (NSDictionary *)framePropertiesWithDelayTime:(float)delayTime {
    
    return @{(NSString *)kCGImagePropertyGIFDictionary:
                 @{(NSString *)kCGImagePropertyGIFDelayTime: @(delayTime)},
             (NSString *)kCGImagePropertyColorModel:(NSString *)kCGImagePropertyColorModelRGB
             };
}

@end
