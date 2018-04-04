//
//  ZBlueToothTools.h
//  ElectromBike
//
//  Created by jianhua zhang on 2018/3/29.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define BBLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#define outTimes 10
//  蓝牙特征值
static CBCharacteristic *characteristicInstance = nil;

//蓝牙状态
typedef enum : NSUInteger {
    BlueToothStateUnknown,          //0.无法识别蓝牙
    BlueToothStateResetting,        //1.蓝牙重置
    BlueToothStateUnsupported,      //2.不支持蓝牙
    BlueToothStateUnauthorized,     //3.未授权
    BlueToothStatePoweredOff,       //4.蓝牙未开启
    BlueToothStatePoweredOn,        //5.蓝牙已开启
    BlueToothStateConnectSuccess,   //6.蓝牙连接成功
    BlueToothStateNotify,           //7.订阅消息    蓝牙特征值 characteristicInstance
    BlueToothStateConnectFail,      //7.蓝牙连接失败
    BlueToothStateDisConnect,       //8.蓝牙连接断开
} BlueToothState;

/*
 * 蓝牙读写Block
 */
typedef void(^BlueToothWriteBlock)(BOOL writeSuccess);

//  delegate
@protocol ZBlueToothToolsDelegate<NSObject>

@optional
/*
 当前蓝牙的连接状态
 * @param       state 蓝牙状态
 */
- (void)blueToothConnectDeviceStated:(BlueToothState)state;

/*
 蓝牙写入状态
 * @param       state 读写状态
 */
- (void)blueToothWriteStatus:(BOOL)isSuccess;

@end

//  简易蓝牙工具，读写数据等
@interface ZBlueToothTools : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

//  蓝牙实例
@property (nonatomic, strong) CBCentralManager *cMgr;
//  已连接到的外设
@property (nonatomic, strong) CBPeripheral *peripheral;

//  附近可连接的外设列表(暂不可使用)
@property (nonatomic, strong) NSMutableArray *peripherals;

//  蓝牙当前连接状态
@property (nonatomic, assign) BlueToothState blueToothState;

//  外设返回的数据
@property (nonatomic, strong) NSDictionary *advertisementData;

//  需要连接的外设mac地址
@property (nonatomic, strong) NSString *macAdress;

//  蓝牙相应数据
@property (nonatomic, strong) NSString *responseStr;

@property (nonatomic, strong) NSString *responseHeadStr;

//  delegate
@property (nonatomic, assign) id<ZBlueToothToolsDelegate> delegate;

//  Block
@property (nonatomic, strong) BlueToothWriteBlock writeBlock;

/*
 * @brief 连接蓝牙
 */
- (void)connectBlueToothWithMACAdress:(NSString *)macAdress;

/*
 * @brief 重连蓝牙
 */
- (void)reConnectBlueTooth;

/*
 * @brief 关闭蓝牙
 */
- (void)closeConnectBlueTooth;

/*
 * @brief 发送指令
 * @param value 指令
 * @param characteristic
 */
- (void)sendValue:(NSString *)value AndBlock:(BlueToothWriteBlock)writeBlock;

@end
