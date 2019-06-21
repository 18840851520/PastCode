//
//  BPush.h
//  Version: 1.5.4
//  百度云推送iOS版本头文件 //
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const BPushRequestErrorCodeKey;
extern NSString *const BPushRequestErrorMsgKey;
extern NSString *const BPushRequestRequestIdKey;
extern NSString *const BPushRequestAppIdKey;
extern NSString *const BPushRequestUserIdKey;
extern NSString *const BPushRequestChannelIdKey;
extern NSString *const BPushRequestResponseParamsKey; // 服务端返回的原始值，其内容和以上的部分值可能有重合

/**
 * @brief 回调方法名字
 *
 */
extern NSString *const BPushRequestMethodBind;
extern NSString *const BPushRequestMethodUnbind;
extern NSString *const BPushRequestMethodSetTag;
extern NSString *const BPushRequestMethodDelTag;
extern NSString *const BPushRequestMethodListTag;

/**
 * @brief 当前推送的环境
 */
typedef NS_ENUM(NSInteger, BPushMode){
    BPushModeDevelopment, // 开发测试环境
    BPushModeProduction, // AppStore 上线环境  AdHoc 内部测试用的生产环境
};

/**
 *	@brief BPushCallBack
 *
 *	@discussion 用来设定异步调用的回调
 */
typedef void (^BPushCallBack)(id result, NSError *error);


@interface BPush : NSObject
/**
 * @brief 注册百度云推送 SDK
 * @param
 *     launchOptions - App 启动时系统提供的参数，表明了 App 是通过什么方式启动的 apiKey - 通过apikey注册百度推送, mode - 当前推送的环境, isdebug - 是否是debug模式。
 * iOS 8 新参数
 * @param rightAction - 快捷回复通知的第一个按钮名字默认为打开应用
 * @param leftAction - 第二个按钮名字默认会关闭应用 iOS 9 快捷回复需要先设置此参数
 * @param category 自定义参数 一组动作的唯一标识 需要与服务端aps的category字段匹配才能展现通知样式 iOS 9 快捷回复需要先设置此参数
 * IOS 9 新参数
 * @param behaviorTextInput 是否启用 iOS 9 快捷回复
 
 */
+ (void)registerChannel:(NSDictionary *)launchOptions apiKey:(NSString *)apikey pushMode:(BPushMode)mode withFirstAction:(NSString *)rightAction withSecondAction:(NSString *)leftAction withCategory:(NSString *)category useBehaviorTextInput:(BOOL)behaviorTextInput isDebug:(BOOL)isdebug;

/**
 * @brief 向云推送注册 device token，只有在注册deviceToken后才可以绑定
 * @param
 *     deviceToken - 通过 AppDelegate 中的 didRegisterForRemoteNotificationsWithDeviceToken 回调获取
 * @return
 *     none
 */
+ (void)registerDeviceToken:(NSData *)deviceToken;

/**
 * 设置access token. 在bindChannel之前调用，如果access token改变后，必须重新设置并且重新bindChannel
 * @param
 *     token - Access Token
 * @return
 *     none
 */
+ (void)setAccessToken:(NSString *)token;

/**
 * 关闭 lbs
 * @param
 *      - 关闭lbs推送模式，默认是开启的，用户可以选择关闭
 * @return
 *     none
 */
+ (void)disableLbs;

/**
 * 开启BPush 崩溃日志收集
 * @param
 *      - 开启BPush 崩溃日志收集 没有使用其他第三方崩溃收集工具的，建议调用此接口，BPush 会收集由于BPush SDK 本身引起的崩溃 便于SDK搜集已知问题，更快的修复问题。
 * @return
 *     none
 */
+ (void)uploadBPushCrashLog;


/**
 * @brief 绑定channel.将会在回调中看获得channnelid appid userid 等。
 * @param
 *     none
 * @return
 *     none
 */


+ (void)bindChannelWithCompleteHandler:(BPushCallBack)handler;

/**
 * @brief解除对 channel 的绑定。
 * @param
 *     none
 * @return
 *     none
 */
+ (void)unbindChannelWithCompleteHandler:(BPushCallBack)handler;

/**
 * @brief设置tag。
 * @param
 *     tag - 需要设置的tag
 * @return
 *     none
 */
+ (void)setTag:(NSString *)tag withCompleteHandler:(BPushCallBack)handler;

/**
 * @brief设置多个tag。
 * @param
 *     tags - 需要设置的tag数组
 * @return
 *     none
 */
+ (void)setTags:(NSArray *)tags withCompleteHandler:(BPushCallBack)handler;

/**
 * @brief删除tag。
 * @param
 *     tag - 需要删除的tag
 * @return
 *     none
 */
+ (void)delTag:(NSString *)tag withCompleteHandler:(BPushCallBack)handler;

/**
 * @brief删除多个tag。
 * @param
 *     tags - 需要删除的tag数组
 * @return
 *     none
 */
+ (void)delTags:(NSArray *)tags withCompleteHandler:(BPushCallBack)handler;

/**
 * @brief获取当前设备应用的tag列表。
 * @param
 *     none
 * @return
 *     none
 */
+ (void)listTagsWithCompleteHandler:(BPushCallBack)handler;

/**
 * @brief 在didReceiveRemoteNotification中调用，用于推送反馈
 * @param
 *     userInfo
 * @return
 *     none
 */
+ (void)handleNotification:(NSDictionary *)userInfo;

/**
 * @brief 用于iOS 10 请求灰度统计接口，在 didRegisterForRemoteNotificationsWithDeviceToken 中调用，用于统计部分灰度用户的到达率情况
 * @param
 *     isOpen 是否开启灰度请求接口
 * @return
 *     none
 */
+ (void)statsGrayInterface:(BOOL)isOpen withAppGroupName:(NSString *)appGroupName withAPPid:(NSString *)appid;

/**
 * @brief获取应用ID，Channel ID，User ID。如果应用没有绑定，那么返回空
 * @param
 *     none
 * @return
 *     appid/channelid/userid
 */
+ (NSString *)getChannelId;
+ (NSString *)getUserId;
+ (NSString *)getAppId;

/**
 * 本地推送，最多支持64个
 * @param fireDate 本地推送触发的时间
 * @param alertBody 本地推送需要显示的内容
 * @param badge 角标的数字。如果不需要改变角标传-1
 * @param alertAction 弹框的按钮显示的内容（IOS 8默认为"打开",其他默认为"启动"）
 * @param userInfo 自定义参数，可以用来标识推送和增加附加信息
 * @param soundName 自定义通知声音，设置为nil为默认声音
 
 * IOS8新参数
 * @param rightAction - 快捷回复通知的第一个按钮名字默认为打开应用
 * @param leftAction - 第二个按钮名字默认会关闭应用 iOS 9 快捷回复需要先设置此参数
 * @param region 自定义参数
 * @param regionTriggersOnce 自定义参数 到达某一区域时，是否触发本地通知
 * @param category 自定义参数 一组动作的唯一标示 默认为nil iOS 9 快捷回复需要先设置此参数
 * IOS 9 新参数
 * @param behaviorTextInput 是否启用 iOS 9 快捷回复

 
 */


+ (void)localNotification:(NSDate *)date alertBody:(NSString *)body badge:(int)bage  withFirstAction:(NSString *)rightAction withSecondAction:(NSString *)leftAction userInfo:(NSDictionary *)userInfo soundName:(NSString *)soundName region:(CLRegion *)region regionTriggersOnce:(BOOL)regionTriggersOnce category:(NSString *)category useBehaviorTextInput:(BOOL)behaviorTextInput;

/**
 * 本地推送在前台推送。默认App在前台运行时不会进行弹窗，在程序接收通知调用此接口可实现指定的推送弹窗。
 * @param notification 本地推送对象
 * @param notificationKey 需要前台显示的本地推送通知的标示符
 */
+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification identifierKey:(NSString *)notificationKey;
/**
 * 删除本地推送
 * @param notificationKey 本地推送标示符
 * @param localNotification 本地推送对象
 */
+ (void)deleteLocalNotificationWithIdentifierKey:(NSString *)notificationKey;
+ (void)deleteLocalNotification:(UILocalNotification *)localNotification;

/**
 * 获取指定通知
 * @param notificationKey 本地推送标示符
 * @return  本地推送对象数组,[array count]为0时表示没找到
 */
+ (NSArray *)findLocalNotificationWithIdentifier:(NSString *)notificationKey;

/**
 * 清除所有本地推送对象
 */
+ (void)clearAllLocalNotifications;


@end




