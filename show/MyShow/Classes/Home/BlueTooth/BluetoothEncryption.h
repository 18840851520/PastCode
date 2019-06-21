//
//  BluetoothEncryption.h
//  ElectromBike
//
//  Created by jianhua zhang on 2018/3/29.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

//上行
#define upLoad @"011102"
//下行
#define downLoad @"A1B102"

@interface BluetoothEncryption : NSObject

// 将命令转换成字节数组
+ (NSData *)agreementWithString:(NSString *)order;

@end
