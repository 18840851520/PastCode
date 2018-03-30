//
//  DefineConstant.m
//  OneHome
//
//  Created by 郭强 on 16/4/7.
//  Copyright © 2016年 guoqiang. A·  ll rights reserved.
//

#import "DefineConstant.h"
#import <CommonCrypto/CommonDigest.h>

@implementation DefineConstant


#pragma mark 从字典 获取String///
NSString* EncodeStringFromDic(NSDictionary *dic, NSString *key)
{
    @try {
        id temp = [dic objectForKey:key];
        if ([temp isKindOfClass:[NSString class]])
        {
            return [NSString stringWithFormat:@"%@",temp];
        }
        else if ([temp isKindOfClass:[NSNumber class]])
        {
            return [NSString stringWithFormat:@"%@",[temp stringValue]];
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
    return nil;
}
#pragma mark 从字典 获取String///
NSString* EncodeNoNilStringFromDic(NSDictionary *dic, NSString *key)
{
    @try {
        id temp = [dic objectForKey:key];
        if ([temp isKindOfClass:[NSString class]])
        {
            return [NSString stringWithFormat:@"%@",temp];
        }
        else if ([temp isKindOfClass:[NSNumber class]])
        {
            return [NSString stringWithFormat:@"%@",[temp stringValue]];
        }
    }
    @catch (NSException *exception) {
        return @"";
    }
    return @"";
}

#pragma mark 从字典 获取Number
NSNumber* EncodeNumberFromDic(NSDictionary *dic, NSString *key)
{
    
    @try {
        id temp = [dic objectForKey:key];
        if ([temp isKindOfClass:[NSString class]])
        {
            return [NSNumber numberWithDouble:[temp doubleValue]];
        }
        else if ([temp isKindOfClass:[NSNumber class]])
        {
            return temp;
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
    return nil;
}

#pragma mark 从字典到字典
NSDictionary *EncodeDicFromDic(NSDictionary *dic, NSString *key)
{
    @try {
        id temp = [dic objectForKey:key];
        if ([temp isKindOfClass:[NSDictionary class]])
        {
            return temp;
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
    return nil;
}
#pragma mark 从字典到数组
NSArray *EncodeArrayFromDic(NSDictionary *dic, NSString *key)
{
    @try {
        id temp = [dic objectForKey:key];
        if ([temp isKindOfClass:[NSArray class]])
        {
            return temp;
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
    return nil;
}


#pragma mark 计算文字度高度
CGFloat GetStringHeight(NSString* text,NSInteger lineSpacing,CGFloat font,CGFloat width){

    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.lineSpacing = lineSpacing;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5};
    
    return [text boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    
}


NSString *GetTimestamp(){
    
    NSDate * date = [NSDate date];
    NSString * timestamp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    return timestamp;
}

#pragma mark md5 加密
NSString * MD5String(NSString* str){

    const char * original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    
    return [hash lowercaseString];

}

#pragma mark 校验身份证
BOOL ValidateIDCardNumber(NSString* cardNo){
    
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;

}

//#pragma mark 获取省份
//NSArray* getProvinceList(){
//    
//    // 读取并加载对照表
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"txt"];
//    
//    NSString* areaJson = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    
//    NSArray* addressArray = [areaJson JSONValue];
//    
//    return addressArray;
//}
//
//
//NSString* getCityIdByName(NSString* name){
//    
//    // 读取并加载
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"txt"];
//    NSString* areaJson = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSArray* addressArray = [areaJson JSONValue];
//    
//    NSString* city_id;
//    for(NSDictionary* p_dict in addressArray){
//        NSArray* c_array = EncodeArrayFromDic(p_dict,@"children");
//        for(NSDictionary* c_dict in c_array){
//            NSString* c_name = EncodeStringFromDic(c_dict,@"name");
//            if([c_name isEqualToString:name]){
//                city_id = EncodeStringFromDic(c_dict,@"id");
//            }
//        }
//    }
//    return city_id;
//}
///**
// * 获市地区ID
// */
//NSString* getAreaIdByName(NSString *cityId,NSString* name){
//    // 读取并加载
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"txt"];
//    NSString* areaJson = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSArray* addressArray = [areaJson JSONValue];
//    
//    NSString* a_id;
//    for(NSDictionary* p_dict in addressArray){
//        NSArray* c_array = EncodeArrayFromDic(p_dict,@"children");
//        for(NSDictionary* c_dict in c_array){
//            NSString* c_id = EncodeStringFromDic(c_dict,@"id");
//            if([c_id isEqualToString:cityId]){
//                NSArray *a_array = EncodeArrayFromDic(c_dict, @"children");
//                for (NSDictionary *a_dict in a_array) {
//                    NSString *a_name = EncodeStringFromDic(a_dict,@"name");
//                    if ([a_name isEqualToString:name]) {
//                        a_id = EncodeStringFromDic(a_dict,@"id");
//                        break;
//                    }
//                }
//                break;
//            }
//        }
//    }
//    return a_id;
//}
//
//NSArray* getCityList(NSString* provinceId){
//    
//    // 读取并加载
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"txt"];
//    NSString* areaJson = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSArray* addressArray = [areaJson JSONValue];
//    
//    NSArray* cityArray;
//    
//    for(NSDictionary* p_dict in addressArray){
//        NSString* p_id = EncodeStringFromDic(p_dict,@"id");
//        if([p_id isEqualToString:provinceId]){
//            cityArray = EncodeArrayFromDic(p_dict,@"children");
//            break;
//        }
//    }
//    return cityArray;
//}
//
//#pragma mark 获取区域数据
//NSArray* getAreaList(NSString*city_id){
//
//    // 读取并加载对照表
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"txt"];
//    
//    NSString* areaJson = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    
//    NSArray* addressArray = [areaJson JSONValue];
//    NSArray* areaArray;
//    for(NSDictionary* p_dict in addressArray){
//        NSArray* c_array = EncodeArrayFromDic(p_dict,@"children");
//        for(NSDictionary* c_dict in c_array){
//            NSString* c_id = EncodeStringFromDic(c_dict,@"id");
//            if([city_id integerValue] == [c_id integerValue]){
//                areaArray = EncodeArrayFromDic(c_dict,@"children");
//                break;
//            }
//        }
//    }
//    
//    return (NSArray*)[[areaArray objectEnumerator] allObjects];;
//}

@end
