//
//  ZBlueToothTools.m
//  ElectromBike
//
//  Created by jianhua zhang on 2018/3/29.
//  Copyright © 2018年 jianhua zhang. All rights reserved.
//

#import "ZBlueToothTools.h"
#import "YMBlueToothTool.h"

//是否返回数据
static bool returned = NO;

@interface ZBlueToothTools()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZBlueToothTools

//  初始化
- (instancetype)init{
    self = [super init];
    if (self) {
        [self cmgr];
    }
    return self;
}

#pragma mark -建立一个Central Manager实例
- (CBCentralManager *)cmgr{
    if(!_cMgr){
        _cMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }else{
        //创建实例的判断是否连接过设备
        if(self.peripheral){
            [_cMgr cancelPeripheralConnection:self.peripheral];
        }
        [self centralManagerDidUpdateState:_cMgr];
    }
    self.peripherals = [NSMutableArray array];
    return _cMgr;
}

- (void)connectBlueToothWithMACAdress:(NSString *)macAdress{
    if([macAdress containsString:@"："] || [macAdress containsString:@":"]){
        [macAdress stringByReplacingOccurrencesOfString:@":" withString:@""];
        [macAdress stringByReplacingOccurrencesOfString:@"：" withString:@""];
    }
    _macAdress = macAdress;
    [self.cMgr scanForPeripheralsWithServices:nil options:nil];
}

- (void)reConnectBlueTooth{
    //  蓝牙是否断开连接
    if(self.peripheral.state == CBPeripheralStateDisconnecting || self.peripheral.state == CBPeripheralStateDisconnected){
        //扫描是否可连接
        [self centralManagerDidUpdateState:_cMgr];
    }
}

- (void)closeConnectBlueTooth{
    //关闭蓝牙连接
    [self.cMgr cancelPeripheralConnection:self.peripheral];
    self.peripheral = nil;
}

- (void)sendValue:(NSString *)value AndBlock:(BlueToothWriteBlock)writeBlock{
    self.writeBlock = writeBlock;
    returned = NO;
    NSData *data = [YMBlueToothTool hexToBytes:value];
    NSLog(@"%s,line = %d,writeValue = %@",__FUNCTION__,__LINE__,data);
    if(characteristicInstance){
        [self.peripheral writeValue:data forCharacteristic:characteristicInstance type:CBCharacteristicWriteWithResponse];
    }
    [self timerCountDown];
}
static int limitTime = 0;
- (void)timerCountDown{
    limitTime = outTimes;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:outTimes target:self selector:@selector(timeCutDown) userInfo:nil repeats:YES];
}
- (void)timeCutDown{
    limitTime --;
    if(limitTime == 0 && !returned){
        //写入超时
        if(self.writeBlock){
            self.writeBlock(NO);
        }
        if([self.delegate respondsToSelector:@selector(blueToothWriteStatus:)]){
            [self.delegate blueToothWriteStatus:NO];
        }
        [self.timer invalidate];
        returned = YES;
    }
}
//写入成功
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if([self.delegate respondsToSelector:@selector(blueToothWriteStatus:)]){
        [self.delegate blueToothWriteStatus:!error];
    }
    if(self.writeBlock){
        self.writeBlock(!error);
    }
    NSLog(@"Write state = %d",!error);
}

#pragma mark -只要中心管理者初始化 就会触发此代理方法 判断手机蓝牙状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case 0:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case 1:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case 2:
            NSLog(@"CBCentralManagerStateUnsupported");//不支持蓝牙
            break;
        case 3:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case 4:
            NSLog(@"CBCentralManagerStatePoweredOff");//蓝牙未开启
            break;
        case 5:{
            NSLog(@"CBCentralManagerStatePoweredOn");//蓝牙已开启
            if(self.macAdress){
                [self.cMgr scanForPeripheralsWithServices:nil // 通过某些服务筛选外设
                                                  options:nil]; // dict,条件
            }
        }
            break;
        default:
            break;
    }
    [self connectState:(NSInteger)central.state];
}

#pragma mark - 中心管理者连接外设成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%s, line = %d, %@=连接成功", __FUNCTION__, __LINE__, peripheral.name);
    // 连接成功之后,可以进行服务和特征的发现
    self.peripheral.delegate = self;
    // 外设发现服务,传nil代表不过滤
    // 这里会触发外设的代理方法 - (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
    [self.peripheral discoverServices:EncodeArrayFromDic(self.advertisementData, @"kCBAdvDataServiceUUIDs")];
    [self connectState:BlueToothStateConnectSuccess];
}

#pragma mark - 发现外设服务里的特征的时候调用的代理方法(这个是比较重要的方法，你在这里可以通过事先知道UUID找到你需要的特征，订阅特征，或者这里写入数据给特征也可以)
//获取外围设备的服务特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    for (CBCharacteristic *characteristic in service.characteristics) {
        characteristicInstance = characteristic;
        [peripheral readValueForCharacteristic:characteristic];
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]) {
            [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    [self connectState:BlueToothStateNotify];
}

#pragma mark - 发现外设后调用的方法
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (peripheral.name) {
        /*
         *  将符合的所有的蓝牙设备都存储到本地 peripherals
         */
        NSString *ManufacturerData = [YMBlueToothTool dataChangeToString:advertisementData[@"kCBAdvDataManufacturerData"]];
        NSLog(@"ManufacturerData:%@,配对Mac:%@,success:%d",ManufacturerData,[[self.macAdress stringByReplacingOccurrencesOfString:@":" withString:@""] lowercaseString],[ManufacturerData hasSuffix:[[self.macAdress stringByReplacingOccurrencesOfString:@":" withString:@""] lowercaseString]]);
        
        if([self.macAdress stringByReplacingOccurrencesOfString:@":" withString:@""] && [ManufacturerData hasSuffix:[[self.macAdress stringByReplacingOccurrencesOfString:@":" withString:@""] lowercaseString]]){
            NSDictionary *data = @{@"peripheral":peripheral,@"advertisementData":advertisementData,@"RSSI":RSSI,};
            [self.peripherals addObject:data];
            self.peripheral = peripheral;
            self.advertisementData = advertisementData;
            
            NSLog(@"%s, line = %d, 连接设备=%@", __FUNCTION__, __LINE__, peripheral.name);
            [self.cMgr connectPeripheral:peripheral options:nil];
            [self.cMgr stopScan];
        }
    }
}

#pragma mark - 外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s, line = %d, %@=连接失败", __FUNCTION__, __LINE__, peripheral.name);
    [self connectState:BlueToothStateConnectFail];
}

#pragma mark - 丢失连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s, line = %d, %@=断开连接", __FUNCTION__, __LINE__, peripheral.name);
    [self connectState:BlueToothStateDisConnect];
}
//  连接状态
- (void)connectState:(BlueToothState)state{
    NSLog(@"%s, line = %d, 当前状态：%ld", __FUNCTION__, __LINE__,state);
    self.blueToothState = state;
    if([self.delegate respondsToSelector:@selector(blueToothConnectDeviceStated:)]){
        [self.delegate blueToothConnectDeviceStated:state];
    }
}
#pragma mark -发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service %@", service);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}
#pragma mark - 蓝牙接收数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error{
    if ([self.delegate respondsToSelector:@selector(blueToothUpdateForCharacteristicValue:withError:)]) {
        [self.delegate blueToothUpdateForCharacteristicValue:characteristic.value withError:error];
    }
}
@end
