//
//  BluetoothEncryption.m
//  ElectromBike
//
//  Created by jianhua zhang on 2018/3/29.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "BluetoothEncryption.h"
#import "YMBlueToothTool.h"

@implementation BluetoothEncryption

+ (NSData *)agreementWithString:(NSString *)order{
    
    NSString *str1 = [order substringWithRange:NSMakeRange(6, order.length-6)];
    //完整指令
    NSString *stt = [order stringByAppendingString:[YMBlueToothTool stringToVerify:str1]];
    //转换成data
    NSData *data1 = [YMBlueToothTool hexToBytes:stt];
    
    return data1;
}

@end
