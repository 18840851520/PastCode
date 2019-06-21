import UIKit
import Flutter
import UserNotifications

@UIApplicationMain


@objc class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate {
    var channelId : String = "";
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self);
        //设置、注册远程推送
        self.requestAuthorization(application: application);
        //Flutter原生交互通道
        self.BPushChannel();
        //注册BPush通道
        BPush.registerChannel(launchOptions, apiKey: "key", pushMode: BPushMode.production, withFirstAction: "next", withSecondAction: "close", withCategory: nil, useBehaviorTextInput: true, isDebug: true);
        //禁用地理位置信息推送
        BPush.disableLbs();
        //
        let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification]
        if userInfo != nil {
            BPush.handleNotification(userInfo as? [AnyHashable : Any])
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions);
    }
    //MARK:注册远程推送通知
    func requestAuthorization(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate;
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
                if granted == true {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
        } else if #available(iOS 8.0, *) {
            let types:UIUserNotificationType = [.badge , .alert , .sound]
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(types: types, categories: nil)
            application.registerUserNotificationSettings(settings)
        } else {
            let types:UIRemoteNotificationType = [UIRemoteNotificationType.alert, UIRemoteNotificationType.badge, .sound]
            application.registerForRemoteNotifications(matching: types)
        }
    }
    //百度推送通道
    func BPushChannel() -> Void {
        //
        let controller = self.window.rootViewController
        //建立rootViewController和Flutter的通信通道
        let pushChannel = FlutterMethodChannel.init(name: "driver.baidu/push", binaryMessenger:controller as! FlutterBinaryMessenger)
        pushChannel.setMethodCallHandler { (FlutterMethodCall, FlutterResult) in
            print("pushChannel");
        }
        //绑定channelId到服务器
        let pushBind = FlutterMethodChannel.init(name: "driver.baidu/push_bind", binaryMessenger: controller as! FlutterBinaryMessenger)
        pushBind.setMethodCallHandler { (FlutterMethodCall, FlutterResult) in
            if(self.channelId.isEmpty){
                print("channelId为空");
                FlutterResult(FlutterMethodNotImplemented);
            } else{
                print("channelId",self.channelId);
                let dic : Dictionary<String,String> = ["channelId":self.channelId];
                let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
                let encodingStr = String(data: data!, encoding: String.Encoding.utf8)!
                
                FlutterResult(encodingStr);
            }
        }
    }
    // 远程推送通知 注册成功
    override func application(_ application: UIApplication , didRegisterForRemoteNotificationsWithDeviceToken deviceToken:Data) {
        //  向云推送注册 device token
        print("deviceToken = %@", deviceToken);
        BPush.registerDeviceToken(deviceToken as Data)
        // 绑定channel.将会在回调中看获得channnelid appid userid 等
        BPush.bindChannel(completeHandler: { (result, error) -> Void in
            if ((result) != nil){
                self.channelId = BPush.getChannelId();
                BPush.setTag("MyTag", withCompleteHandler: { (result, error) -> Void in
                    if ((result) != nil){
                    }
                })
            }
        })
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken:deviceToken)
    }
    override func application(_ application: UIApplication , didFailToRegisterForRemoteNotificationsWithError error: Error ) {
        
        print("deviceToken = %@", error);
        if error._code == 3010 {
            
        } else {
            
        }
        super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    func application(application: UIApplication , didReceiveRemoteNotification userInfo: [ NSObject : AnyObject ]) {
        
        // App 收到推送的通知
        
        BPush.handleNotification(userInfo as [NSObject : AnyObject]!)
        
        let notif    = userInfo as NSDictionary
        
        let apsDic  = notif.object ( forKey: "aps" ) as! NSDictionary
        
        let alertDic = apsDic.object ( forKey: "alert" ) as! String
        
        // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
        
        if (application.applicationState == UIApplicationState.active || application.applicationState == UIApplicationState.background) {
            
            let alertView = UIAlertView (title: "收到一条消息", message: alertDic, delegate: nil , cancelButtonTitle: " 取消 ",otherButtonTitles:"确定")
            
            alertView.show ()
            
        }
        else//杀死状态下，直接跳转到跳转页面。
        {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "finish")
            
            // 根视图是普通的viewctr 用present跳转
            let tabBarCtr = self.window?.rootViewController
            tabBarCtr?.present(vc, animated: true, completion: nil)
            
        }
    }
    func application(application: UIApplication , didReceiveRemoteNotification userInfo: [ NSObject : AnyObject ], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult ) -> Void ) {
        
        let notif    = userInfo as NSDictionary
        
        let apsDic  = notif.object ( forKey: "aps" ) as! NSDictionary
        
        let alertDic = apsDic.object ( forKey: "alert" ) as! String
        
        // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
        
        if (application.applicationState == UIApplicationState.active || application.applicationState == UIApplicationState.background) {
            
            let alertView = UIAlertView (title: "收到一条消息", message: alertDic, delegate: nil , cancelButtonTitle: " 取消 ",otherButtonTitles:"确定")
            
            alertView.show ()
            
        }
            
        else//杀死状态下，直接跳转到跳转页面。
            
        {
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = sb.instantiateViewController(withIdentifier: "finish")
            
            // 根视图是普通的viewctr 用present跳转
            
            let tabBarCtr = self.window?.rootViewController
            
            tabBarCtr?.present(vc, animated: true, completion: nil)
            
        }
    }
}
