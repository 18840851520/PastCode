//
//  YMBlueToothTool.h
//  fmyqApp
//
//  Created by iOS on 2017/7/19.
//  Copyright © 2017年 qixiangnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMBlueToothTool : NSObject

#pragma mark - 进制转换

/**
 * short整数转换为2字节的byte数组
 *
 * @param s short整数
 * @return byte数组
 */
+ (Byte)intToByte2:(NSInteger)s;

/**
 * int整数转换为1字节的byte数组
 *
 * @param -b整数
 * @return byte数组
 */
+ (Byte)intToByte1:(NSInteger)n;

/**
 十六进制 String 转 Data(bytes)
 
 @param string 十六进制 String
 @return Data(bytes)
 */
+ (NSData *)hexToBytes:(NSString *)string;

/**
 Data(bytes) 转 十六进制 String
 
 @param data Data(bytes)
 @return 十六进制 String
 */
+ (NSString *)dataChangeToString:(NSData *)data;

/**
 十六进制转十进制
 
 @param hex 十六进制
 @return 十进制
 */
+ (NSString *)toTen:(NSString *)hex;

/**
 十进制转十六进制
 
 @param tmpid 十进制 int
 @return 十六进制
 */
+ (NSString *)toHex:(long long int)tmpid;

/**
 大小端数据转换
 
 @param data data
 @return data
 */
+ (NSData *)dataTransfromBigOrSmall:(NSData *)data;

#pragma mark - 补位

/**
 补位
 
 @param addString 占位字符串
 @param length 总长度
 @param string 需补位的字符串
 @return 补位后的字符串
 */
+ (NSString *)addString:(NSString *)addString Length:(NSInteger)length OnString:(NSString *)string;

#pragma mark - 获取时间大端表示

/**
 获取时间大端表示
 
 @param number 时间戳
 @param length 总长度
 @return 大端表示的时间
 */
+ (NSString *)intToHexString:(NSInteger)number length:(NSInteger)length;

#pragma mark - 校验和

/**
 算出校验和
 @param string 十六进制字符串
 @return 校验和
 */
+ (NSString *)xorWithHex:(NSString *)string;

#pragma mark - 分包

/**
 分包
 @param write 需要输入的字符串
 @return 分包数组
 */
+ (NSMutableArray *)arrayToWrite:(NSString *)write;

/*
 *  @brief  10进制转进制 按字节个数补位（每个字节占2位）
 *  @param  decimalism  十进制数字
 *  @param  addStr 添加的地址
 *  @return 十六进制
 */
+ (NSString *)toHexByString:(NSInteger)decimalism AndByteCount:(NSInteger)count ByAddString:(NSString *)addStr;
/*
 *  @brief  10进制转进制 按字节个数补位（每个字节占2位）
 *  @param  decimalism  十进制数字
 *  @return 十六进制
 */
+ (NSString *)toHexByString:(NSInteger)decimalism AndByteCount:(NSInteger)count;
/*
 *  @brief  校验和
 *  @param  verify输入字符串
 *  @return 校验码
 */
+ (NSString *)stringToVerify:(NSString *)verify;
/*
 *  @brief  字节数组长度
 *  @return 校验码
 */
+ (NSInteger)byteLengthWithString:(NSData *)byteData;

@end
