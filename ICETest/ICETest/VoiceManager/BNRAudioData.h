//
//  BNRAudioData.h
//  BleVOIP
//
//  Created by JustinYang on 16/6/30.
//  Copyright © 2016年 JustinYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface BNRAudioData : NSObject
@property (nonatomic,readonly) NSData *data;
@property (nonatomic,readonly) AudioStreamPacketDescription packetDescription;

+ (instancetype)parsedAudioDataWithBytes:(const void *)bytes
                       packetDescription:(AudioStreamPacketDescription)packetDescription;
@end
