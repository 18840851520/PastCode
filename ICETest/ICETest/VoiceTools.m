//
//  VoiceTools.m
//  ICETest
//
//  Created by 划落永恒 on 2018/12/19.
//  Copyright © 2018 com.hualuoyongheng. All rights reserved.
//

#import "VoiceTools.h"
#import <AudioUnit/AudioUnit.h>

@interface VoiceTools()

@property (nonatomic, assign) AudioUnit rioUnit;
@property (nonatomic, assign) AudioBufferList bufferList;

@end

@implementation VoiceTools

+ (VoiceTools *) sharedAudioManager{
    
    static VoiceTools *sharedAudioManager;
    @synchronized(self)
    {
        if (!sharedAudioManager) {
            sharedAudioManager = [[VoiceTools alloc] init];
        }
        return sharedAudioManager;
    }
}


@end
