//
//  BNRAudioData.m
//  BleVOIP
//
//  Created by JustinYang on 16/6/30.
//  Copyright © 2016年 JustinYang. All rights reserved.
//

#import "BNRAudioData.h"

@implementation BNRAudioData
@synthesize data = _data;
@synthesize packetDescription = _packetDescription;

+ (instancetype)parsedAudioDataWithBytes:(const void *)bytes
                       packetDescription:(AudioStreamPacketDescription)packetDescription
{
    return [[self alloc] initWithBytes:bytes
                     packetDescription:packetDescription];
}

- (instancetype)initWithBytes:(const void *)bytes packetDescription:(AudioStreamPacketDescription)packetDescription
{
    if (bytes == NULL || packetDescription.mDataByteSize == 0)
    {
        return nil;
    }
    
    self = [super init];
    if (self)
    {
        _data = [NSData dataWithBytes:bytes length:packetDescription.mDataByteSize];
        _packetDescription = packetDescription;
    }
    return self;
}

@end
