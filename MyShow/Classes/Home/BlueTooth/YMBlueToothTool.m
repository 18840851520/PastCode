//
//  YMBlueToothTool.m
//
//  Created by iOS on 2017/7/19.
//  Copyright © 2017年 qixiangnet. All rights reserved.
//

#import "YMBlueToothTool.h"

@implementation YMBlueToothTool


/**
 * short整数转换为2字节的byte数组
 *
 * @param s short整数
 * @return byte数组
 */
+ (Byte)intToByte2:(NSInteger)s{
    Byte target[2] = {};
    target[0] = (Byte) (s >> 8 & 0xFF);
    target[1] = (Byte) (s & 0xFF);
    return target;
}
/**
 * int整数转换为1字节的byte数组
 *
 * @param -b整数
 * @return byte数组
 */
+ (Byte)intToByte1:(NSInteger)n{
    Byte b[1] = {};
    b[0] = (Byte) (n & 0xff);
    return b;
}

#pragma mark - 进制转换
+ (NSString *)decodeHexWithData:(NSData *)data{
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if(!dataBuffer)
    {
        return [NSString string];
    }
    NSUInteger      dataLength = [data length];
    NSMutableString *hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; i++) {
        [hexString appendFormat:@"%02X",(unsigned int)dataBuffer[i]];
    }
    return [NSString stringWithString:hexString];
}

/**
 十六进制 String 转 Data(bytes)
 @param string 十六进制 String
 @return Data(bytes)
 */
+ (NSData *)hexToBytes:(NSString *)string {
    NSMutableData *data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= string.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString *hexString = [string substringWithRange:range];
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return [data copy];
}
+ (NSData *)encodeHexWithHexString:(NSString *)hexStr{
    if(!hexStr || [hexStr length] == 0){
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if([hexStr length] % 2 ==0){
        range = NSMakeRange(0, 2);
    }else{
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location;i < [hexStr length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [hexStr substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location +=range.length;
        range.length = 2;
    }
    
    return hexData;
}

/**
 Data(bytes) 转 十六进制 String
 
 @param data Data(bytes)
 @return 十六进制 String
 */
+ (NSString *)dataChangeToString:(NSData *)data {
    NSString *string = [NSString stringWithFormat:@"%@",data];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}

/**
 十六进制转十进制

 @param hex 十六进制
 @return 十进制
 */
+ (NSString *)toTen:(NSString *)hex {
    NSString *ten = [NSString stringWithFormat:@"%lu",strtoul([hex UTF8String],0,16)];
    return ten;
}

/**
 十进制转十六进制

 @param tmpid 十进制 int
 @return 十六进制
 */
+ (NSString *)toHex:(long long int)tmpid {
    NSString *nLetterValue;
    NSString *str = @"";
    long long int ttmpig;
    for (int i = 0; i < 9; i++) {
        ttmpig = tmpid % 16;
        tmpid = tmpid / 16;
        switch (ttmpig) {
            case 10: {
                nLetterValue = @"A";
                break;
            }
            case 11: {
                nLetterValue = @"B";
                break;
            }
            case 12: {
                nLetterValue = @"C";
                break;
            }
            case 13: {
                nLetterValue = @"D";
                break;
            }
            case 14: {
                nLetterValue = @"E";
                break;
            }
            case 15: {
                nLetterValue = @"F";
                break;
            }
            default: {
                nLetterValue = [[NSString alloc] initWithFormat:@"%lli",ttmpig];
                break;
            }
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}

/**
 大小端数据转换
 
 @param data data
 @return data
 */
+ (NSData *)dataTransfromBigOrSmall:(NSData *)data {
    NSString *tempString = [self dataChangeToString:data];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (int i = 0; i < data.length * 2 ; i+=2) {
        NSString *string = [tempString substringWithRange:NSMakeRange(i, 2)];
        [tmpArray addObject:string];
    }
    
    NSArray *lastArray = [[tmpArray reverseObjectEnumerator] allObjects];
    NSMutableString *lastString = [NSMutableString string];
    
    for (NSString *string in lastArray) {
        [lastString appendString:string];
    }
    
    NSData *lastData = [self hexToBytes:lastString];
    return lastData;
}

#pragma mark - 补位

/**
 补位

 @param addString 占位字符串
 @param length 总长度
 @param string 需补位的字符串
 @return 补位后的字符串
 */
+ (NSString *)addString:(NSString *)addString Length:(NSInteger)length OnString:(NSString *)string {
    NSMutableString *nullString = [[NSMutableString alloc] initWithString:@""];
    if ((length - string.length) > 0) {
        for (int i = 0; i < (length - string.length); i++) {
            [nullString appendString:addString];
        }
    }
    return [NSString stringWithFormat:@"%@%@",nullString,string];
}

#pragma mark - 获取时间大端表示

/**
 获取时间大端表示

 @param number 时间戳
 @param length 总长度
 @return 大端表示的时间
 */
+ (NSString *)intToHexString:(NSInteger)number length:(NSInteger)length {
    NSString *result = [self addString:@"0" Length:length OnString:[self toHex:(long long int)number]];
    NSData *data = [self hexToBytes:result];
    NSData *lastData = [self dataTransfromBigOrSmall:data];
    
    result = [self dataChangeToString:lastData];
    return result;
}

#pragma mark - 校验和

/**
 算出校验和

 @param string 十六进制字符串
 @return 校验和
 */
+ (NSString *)xorWithHex:(NSString *)string {
    int idx;
    unsigned long result = 00;
    for (idx = 0; idx+2 <= string.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString *hexStr = [string substringWithRange:range];
        unsigned long hex = strtoul([hexStr UTF8String], 0, 16);
        result = result ^ hex;
    }
    return [NSString stringWithFormat:@"%@",[self toHex:result]];
}

#pragma mark - 分包

/**
 分包

 @param write 需要输入的字符串
 @return 分包数组
 */
+ (NSMutableArray *)arrayToWrite:(NSString *)write {
    write = [write uppercaseStringWithLocale:[NSLocale currentLocale]];
    float limit = 40; //一个字节2位数，蓝牙通讯限制20字节
    NSMutableArray *array = [NSMutableArray array];
    NSInteger count = ceilf(write.length / limit);
    NSInteger left = write.length % (int)limit == 0 ? limit : write.length % (int)limit;
    for (int i = 0; i < count; i++) {
        NSString *string;
        if (i != (count - 1)) {
            string = [write substringWithRange:NSMakeRange(i * limit, limit)];
        }else {
            string = [write substringWithRange:NSMakeRange(i * limit, left)];
        }
        [array addObject:string];
    }
    return array;
}

/*
 *  @brief  10进制转进制 按字节个数补位（每个字节占2位）
 *  @param  decimalism  十进制数字
 *  @param  addStr 添加的地址
 *  @return 十六进制
 */
+ (NSString *)toHexByString:(NSInteger)decimalism AndByteCount:(NSInteger)count ByAddString:(NSString *)addStr{
    addStr = (addStr == nil) ? @"0":addStr;
    if(decimalism){
        return [YMBlueToothTool addString:addStr Length:count*2 OnString:[YMBlueToothTool toHex:decimalism]];
    }
    return nil;
}
/*
 *  @brief  10进制转进制 按字节个数补位（每个字节占2位）
 *  @param  decimalism  十进制数字
 *  @return 十六进制
 */
+ (NSString *)toHexByString:(NSInteger)decimalism AndByteCount:(NSInteger)count{
    if(decimalism){
        return [YMBlueToothTool addString:@"0" Length:count*2 OnString:[YMBlueToothTool toHex:decimalism]];
    }
    return @"00";
}
/*
 *  @brief  校验和
 *  @param  verify输入字符串
 *  @return 校验码
 */
+ (NSString *)stringToVerify:(NSString *)verify{
    Byte A;
    for (int i = 0;i < verify.length / 2; i++) {
        NSString *u = [verify substringWithRange:NSMakeRange(2 * i, 2)];
        unsigned long num1 = strtoul([u UTF8String],0,16);
        A = num1 + A;
    }
    //校验
    Byte B = ~A;
    return [NSString stringWithFormat:@"%02X",B];
}
@end
