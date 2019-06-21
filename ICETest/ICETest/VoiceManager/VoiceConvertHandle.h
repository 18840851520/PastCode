//
//  VoiceConvertHandle.h
//  BleVOIP
//
//  Created by JustinYang on 16/6/14.
//  Copyright © 2016年 JustinYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VoiceConvertHandleDelegate <NSObject>
//转码数据
-(void)covertedData:(NSData *)data;

@end

@interface VoiceConvertHandle : NSObject

@property (nonatomic,weak) id<VoiceConvertHandleDelegate> delegate;
//开始录音
@property (nonatomic)   BOOL    startRecord;
//语音单例
+(instancetype)shareInstance;
//播放音频
-(void)playWithData:(NSData *)data;

@end
