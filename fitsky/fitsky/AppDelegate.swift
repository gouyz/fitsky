//
//  AppDelegate.swift
//  fitsky
//
//  Created by gouyz on 2019/7/9.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

import UserNotifications
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    /// 高德地图定位
    let locationManager: AMapLocationManager = AMapLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /// 检测网络状态
        networkManager?.startListening()
        
        /// 设置键盘控制
        setKeyboardManage()
        /// 高德地图
        AMapServices.shared().apiKey = kLBSMapAppKey
        //微信注册
        WXApi.registerApp(kWeChatAppID, enableMTA: true)
        GYZTencentShare.shared.registeApp(kQQAppID)
        
        RCIM.shared()?.initWithAppKey(kRCIMAppKey)
        RCIM.shared()?.connectionStatusDelegate = self
        RCIM.shared()?.receiveMessageDelegate = self
        RCIM.shared()?.userInfoDataSource = self
        RCIM.shared()?.groupInfoDataSource = self
        RCIM.shared()?.globalConversationPortraitSize = CGSize.init(width: 46, height: 46)
        RCIM.shared()?.enableTypingStatus = true
        /// //融云即时通讯 消息推送通知
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMessageNotification(notification:)), name: NSNotification.Name.RCKitDispatchMessage, object: nil)
        
        // [ GTSDK ]：使用APPID/APPKEY/APPSECRENT启动个推
        GeTuiSdk.start(withAppId: kGtAppId, appKey: kGtAppKey, appSecret: kGtAppSecret, delegate: self)
        // [ 参考代码，开发者注意根据实际需求自行修改 ] 注册远程通知
        self.registerRemoteNotification();
        
        // badge清零
        resetBadge()
        
        ///本地获取城市信息
        let model = userDefaults.data(forKey: ALLCITYINFO)
        if model == nil {
            
            requestAllCityList()
        }else{
            requestCityUpdate()
        }
        
        initLocation()
        //初始化动图资源
        AliyunEffectPrestoreManager.init().insertInitialData()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = kWhiteColor
        
        if newFeature() {//引导页
            window?.rootViewController = ViewController()
        }else if userDefaults.bool(forKey: kIsLoginTagKey) {
            
            loginAndEnterMainPage()
            //如果未登录进入登录界面，登录后进入首页
            window?.rootViewController = GYZMainTabBarVC()
        }else{
            goLogin()
        }
        //        window?.rootViewController = GYZBaseNavigationVC(rootViewController: FSLoginVC())
        window?.makeKeyAndVisible()
        
        // 获取推送消息
        let remote = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable : Any]
        // 如果remote不为空，就代表应用在未打开的时候收到了推送消息
        if remote != nil {
            // 收到推送消息实现的方法
            self.perform(#selector(receivePush), with: remote, afterDelay: 1.0);
        }
        requestVersion()
        sleep(2)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    ///（App即将进入前台）中将小红点角标清除
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return dealPayResult(url: url)
    }
    // NOTE: 9.0以后使用新API接口
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return dealPayResult(url: url)
    }
    
    ///获取城市数据 并保存本地
    func requestAllCityList(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        GYZNetWork.requestNetwork("Home/ChinaArea/city",parameters: nil,  success: { (response) in
            
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].dictionaryObject else { return }
                
                let cityModel = FSCityModel.init(dict: data)
                
                if cityModel.cityListDic.count > 0{
                    let model = NSKeyedArchiver.archivedData(withRootObject: cityModel)
                    userDefaults.set(model, forKey: ALLCITYINFO)
                }
                
            }
            
        }, failture: { (error) in
            
            GYZLog(error)
        })
    }
    
    ///城市更新接口
    func requestCityUpdate(){
        if !GYZTool.checkNetWork() {
            return
        }
        weak var weakSelf = self
        var cityVersion:String = "1.0.0"
        if let version = userDefaults.string(forKey: CURRCITYVersionINFO) {
            cityVersion = version
        }
        GYZNetWork.requestNetwork("Home/ChinaArea/update",parameters: ["version":cityVersion,"type":"1"],  success: { (response) in
            
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                userDefaults.set(response["data"]["version"].stringValue, forKey: CURRCITYVersionINFO)
                if response["data"]["is_update"].stringValue == "1" {//是否更新（0-否 1-是）
                    weakSelf?.requestAllCityList()
                }
            }
            
        }, failture: { (error) in
            
            GYZLog(error)
        })
    }
    
    /// 设置键盘控制
    func setKeyboardManage(){
        //控制自动键盘处理事件在整个项目内是否启用
        IQKeyboardManager.shared.enable = true
        //点击背景收起键盘
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        //隐藏键盘上的工具条(默认打开)
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    ///支付宝/微信回调
    func dealPayResult(url: URL) -> Bool{
        
        var result: Bool = true
        if url.host == "safepay" {// 支付宝
            //跳转支付宝钱包进行支付，处理支付结果
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic) in
                GYZLog(resultDic)
                if let alipayjson = resultDic {
                    /// 支付后回调
                    AliPayManager.shared.showResult(result: alipayjson as! [String: Any])
                }
                
            })
            
            //授权回调
            AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { (resultDic) in
                GYZLog(resultDic)
                if let alipayjson = resultDic {
                    /// 支付后回调
                    AliPayManager.shared.showAuth_V2Result(result: alipayjson as! [String : Any])
                }
            })
        }else if url.host == "qzapp" || url.host == "response_from_qq" {// QQ授权登录或QQ 分享
            
            result = GYZTencentShare.shared.handle(url)
        }else{//微信
            result = WXApi.handleOpen(url, delegate:WXApiManager.shared)
        }
        
        return result
    }
    
    /// 初始化高德地图定位
    func initLocation(){
        locationManager.delegate = self
        /// 设置定位最小更新距离
        locationManager.distanceFilter = 200
        locationManager.locatingWithReGeocode = true
        locationManager.startUpdatingLocation()
    }
    // 去登录
    func goLogin(){
        window?.rootViewController = GYZBaseNavigationVC(rootViewController: FSLoginVC())
    }
    /// 融云消息通知
    @objc func didReceiveMessageNotification(notification:Notification){
        let left = notification.userInfo!["left"] as! Int
        if RCIMClient.shared()?.sdkRunningMode == RCSDKRunningMode.background && left == 0 {
            let unreadMsgCount = getTotalUnreadCount()
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = Int(unreadMsgCount)
            }
        }
    }
    /// 未读消息数量
    func getTotalUnreadCount() -> Int32{
        let unreadMsgCount = RCIMClient.shared()?.getUnreadCount([RCConversationType.ConversationType_PRIVATE,RCConversationType.ConversationType_GROUP,RCConversationType.ConversationType_SYSTEM])
        return unreadMsgCount ?? 0
    }
    
    func loginAndEnterMainPage(){
        let token = userDefaults.string(forKey: "imToken")
        let userId = userDefaults.string(forKey: "userId")
        let userNickName = userDefaults.string(forKey: "nickname")
        let userPortraitUri = userDefaults.string(forKey: "avatar")
        
        if token?.count > 0 && userId?.count > 0 {
            let _currentUserInfo: RCUserInfo = RCUserInfo.init(userId: userId, name: userNickName, portrait: userPortraitUri)
            RCIM.shared()?.currentUserInfo = _currentUserInfo
            
            RCDIMService.shared().connect(withToken: token!, dbOpened: { (code) in
                
            }, success: { (userId) in
                // 从服务器获取用户信息
                GYZNetWork.requestNetwork("Member/Login/getMemberInfo",parameters: nil,  success: {(response) in
                    
                    GYZLog(response)
                    if response["result"].intValue == kQuestSuccessTag{//请求成功
                        let userInfo = response["data"]["u"]
                        let nick_name = userInfo["nick_name"].stringValue
                        userDefaults.set(nick_name, forKey: "nickname")
                        userDefaults.set(userInfo["avatar"].stringValue, forKey: "avatar")
                        userDefaults.set(userInfo["im_data"]["member_id"].stringValue, forKey: "userId")
                        userDefaults.set(userInfo["im_data"]["im_token"].stringValue, forKey: "imToken")
                        let currentUserInfo = RCUserInfo.init(userId: userInfo["im_data"]["member_id"].stringValue, name: nick_name, portrait: userInfo["avatar"].stringValue)
                        RCIMClient.shared()?.currentUserInfo = currentUserInfo
                    }
                    
                }, failture: { (error) in
                    
                    GYZLog(error)
                })
                
            }, error: { (status) in
                let _currentUserInfo: RCUserInfo = RCUserInfo.init(userId: userId, name: userNickName, portrait: nil)
                RCIM.shared()?.currentUserInfo = _currentUserInfo
            }) {
                DispatchQueue.main.async {
                    GYZTool.removeUserInfo()
                    self.goLogin()
                    
                    let alert = UIAlertView.init(title: "温馨提示", message: "Token已过期，请重新登录", delegate: self, cancelButtonTitle: "确定")
                    alert.show()
                }
            }
        }else {
            self.goLogin()
        }
    }
}

extension AppDelegate : GeTuiSdkDelegate, UNUserNotificationCenterDelegate {
    
    /// 融云 推送处理2
    //注册用户通知设置
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    // MARK: - 远程通知(推送)回调
    
    /// [ 系统回调 ] 远程通知注册成功回调，获取DeviceToken成功，同步给个推服务器
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // [ GTSDK ]：（新版）向个推服务器注册deviceToken
        GeTuiSdk.registerDeviceTokenData(deviceToken);
        
        // 融云推送处理
        RCIMClient.shared()?.setDeviceTokenData(deviceToken)
        
        NSLog("[ TestDemo ] [ DeviceToken(NSData) ]: %@ \n", NSData.init(data: deviceToken));
    }
    
    /// [ 系统回调:可选 ] 远程通知注册失败回调，获取DeviceToken失败，打印错误信息
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("[ TestDemo ] [DeviceToken Error]: %@ \n", error.localizedDescription);
    }
    
    // MARK: - iOS 10中收到推送消息
    
    /// [ 系统回调 ] iOS 10 通知方法: APNs通知将要显示时触发
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // [ 测试代码 ] 日志打印APNs信息
        NSLog("[ TestDemo ] [APNs] willPresentNotification: %@", notification.request.content.userInfo);
        
        // [ 参考代码，开发者注意根据实际需求自行修改 ] 根据APP需要，判断是否要提示用户Badge、Sound、Alert
        completionHandler([.badge,.sound,.alert]);
    }
    
    /// [ 系统回调 ] iOS 10 通知方法: APNs点击通知时触发
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // [ 测试代码 ] 日志打印APNs信息
        NSLog("[ TestDemo ] [APNs] didReceiveNotificationResponse: %@", response.notification.request.content.userInfo);
        
        // [ GTSDK ]：将收到的APNs信息传给个推统计
        GeTuiSdk.handleRemoteNotification(response.notification.request.content.userInfo);
        /**
         *  iOS的应用程序分为3种状态
         *      1、前台运行的状态UIApplicationStateActive；
         *      2、后台运行的状态UIApplicationStateBackground；
         *      3、app待激活状态UIApplicationStateInactive。
         */
        // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
        if (UIApplication.shared.applicationState == .active) || (UIApplication.shared.applicationState == .background){
            //            showWarnAlert()
        }else{
            receivePush(response.notification.request.content.userInfo)
        }
        // badge清零
        resetBadge()
        
        completionHandler();
    }
    
    // MARK: - APP运行中接收到通知(推送)处理 - iOS 10 以下
    
    /// [ 系统回调 ] App收到远程通知
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // [ 测试代码 ] 日志打印APNs信息
        NSLog("[ TestDemo ] [APNs] didReceiveRemoteNotification: %@", userInfo);
        
        // [ GTSDK ]：将收到的APNs信息传给个推统计
        GeTuiSdk.handleRemoteNotification(userInfo);
        
        /**
         *  iOS的应用程序分为3种状态
         *      1、前台运行的状态UIApplicationStateActive；
         *      2、后台运行的状态UIApplicationStateBackground；
         *      3、app待激活状态UIApplicationStateInactive。
         */
        // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
        if (application.applicationState == .active) || (application.applicationState == .background){
            //            showWarnAlert()
        }else{
            receivePush(userInfo)
        }
        // badge清零
        resetBadge()
        
        // [ 参考代码，开发者注意根据实际需求自行修改 ] 根据APP需要自行修改参数值
        completionHandler(UIBackgroundFetchResult.newData);
    }
    
    // MARK: - GeTuiSdkDelegate
    
    /// [ GTSDK回调 ] SDK启动成功返回cid
    func geTuiSdkDidRegisterClient(_ clientId: String!) {
        // [ GTSDK ]：个推SDK已注册，返回clientId
        NSLog("[ TestDemo ] [GTSdk RegisterClient]:%@\n\n", clientId);
        requestPushMemberClientID(clientId: clientId)
    }
    // 接收到推送实现的方法
    @objc func receivePush(_ userInfo : [AnyHashable : Any]) {
        /// 消息推送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kJPushRefreshData), object: nil,userInfo:userInfo)
    }
    
    ///获取消息推送 cid
    func requestPushMemberClientID(clientId: String){
        if !GYZTool.checkNetWork() {
            return
        }
        
        GYZNetWork.requestNetwork("Member/MemberClient/add",parameters: ["client_id":clientId,"client_type":"1"],  success: { (response) in
            
            GYZLog(response)
            
        }, failture: { (error) in
            
            GYZLog(error)
        })
    }
    
    /// [ GTSDK回调 ] SDK收到透传消息回调
    func geTuiSdkDidReceivePayloadData(_ payloadData: Data!, andTaskId taskId: String!, andMsgId msgId: String!, andOffLine offLine: Bool, fromGtAppId appId: String!) {
        
        // 数据转换
        var payloadMsg = "";
        if((payloadData) != nil) {
            payloadMsg = String.init(data: payloadData, encoding: String.Encoding.utf8)!;
        }
        
        //        let paramDic = payloadMsg.convertStringToDictionary()
        //        let paramPayLoad = paramDic!["payload"] as? [String:String]
        //        GYZLog(paramPayLoad)
        // [ 测试代码 ] 控制台打印日志
        let msg:String = "Receive Payload: \(payloadMsg), taskId:\(String(describing: taskId)), messageId:\(String(describing: msgId))";
        NSLog("[ TestDemo ] [GTSdk ReceivePayload]:%@\n\n",msg);
    }
    
    /// [ GTSDK回调 ] SDK收到sendMessage消息回调
    func geTuiSdkDidSendMessage(_ messageId: String!, result: Int32) {
        // [ 测试代码 ] 控制台打印日志
        let msg:String = "sendmessage=\(String(describing: messageId)),result=\(result)";
        NSLog("[ TestDemo ] [GeTuiSdk DidSendMessage]:%@\n\n",msg);
    }
    // MARK: - 用户通知(推送) _自定义方法
    
    /**
     * [ 参考代码，开发者注意根据实际需求自行修改 ] 注册远程通知
     *
     * 警告：Xcode8及以上版本需要手动开启“TARGETS -> Capabilities -> Push Notifications”
     * 警告：该方法需要开发者自定义，以下代码根据APP支持的iOS系统不同，代码可以对应修改。以下为参考代码
     * 注意根据实际需要修改，注意测试支持的iOS系统都能获取到DeviceToken
     *
     */
    func registerRemoteNotification() {
        let systemVer = (UIDevice.current.systemVersion as NSString).floatValue;
        
        if systemVer >= 10.0 {
            if #available(iOS 10.0, *) {
                let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
                center.delegate = self;
                center.requestAuthorization(options: [.alert,.badge,.sound], completionHandler: { (granted:Bool, error:Error?) -> Void in
                    if (granted) {
                        NSLog("注册通知成功")  // 点击允许
                    } else {
                        NSLog("注册通知失败")  // 点击不允许
                    }
                })
                
                UIApplication.shared.registerForRemoteNotifications()
                
                return;
            }
        }
        
        if systemVer >= 8.0 {
            if #available(iOS 8.0, *) {
                let userSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(userSettings)
                
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    /// 极光推送重置角标
    func resetBadge(){
        // badge清零
        UIApplication.shared.applicationIconBadgeNumber = 0
        GeTuiSdk.resetBadge()
    }
}
extension AppDelegate:AMapLocationManagerDelegate{
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode?) {
        NSLog("location:{lat:\(location.coordinate.latitude); lon:\(location.coordinate.longitude); accuracy:\(location.horizontalAccuracy);};");
        
        // 存储定位经纬度
        userDefaults.set(location.coordinate.latitude, forKey: CURRlatitude)
        userDefaults.set(location.coordinate.longitude, forKey: CURRlongitude)
        locationManager.stopUpdatingLocation()
        if let reGeocode = reGeocode {
            //            locationManager.stopUpdatingLocation()
            NSLog("reGeocode:%@", reGeocode)
        }
    }
    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        
    }
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        GYZLog(error)
    }
    
}

extension AppDelegate{
    /// 请求服务器版本
    func requestVersion(){
        if !GYZTool.checkNetWork() {
            return
        }
        weak var weakSelf = self
        
        GYZNetWork.requestNetwork("Home/Index/update",parameters: ["version":GYZUpdateVersionTool.getCurrVersion(),"type":"1"],  success: { (response) in
            
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
                guard let data = response["data"].dictionaryObject else { return }
                
                let versionModel = FSVersionModel.init(dict: data)
                
                if GYZUpdateVersionTool.getCurrVersion() < versionModel.version {
                    if versionModel.is_must == "1" {
                        weakSelf?.updateNeedVersion(version: versionModel.title!, content: versionModel.des!)
                    }else if versionModel.is_update == "1" {
                        weakSelf?.updateVersion(version: versionModel.title!, content: versionModel.des!)
                    }
                }
            }
            
        }, failture: { (error) in
            
            GYZLog(error)
        })
    }
    /**
     * //不强制更新
     * @param version 版本名称
     * @param content 更新内容
     */
    func updateVersion(version: String,content: String){
        let alert = UIAlertView.init(title: version, message: content, delegate: self, cancelButtonTitle: "残忍拒绝", otherButtonTitles: "立即更新")
        alert.tag = 101
        alert.show()
    }
    /**
     * 强制更新
     * @param version 版本名称
     * @param content 更新内容
     */
    func updateNeedVersion(version: String,content: String){
        
        let alert = UIAlertView.init(title: version, message: content, delegate: self, cancelButtonTitle: "立即更新")
        alert.tag = 102
        alert.show()
    }
}
extension AppDelegate : UIAlertViewDelegate{
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        let tag = alertView.tag
        if tag == 101{
            if buttonIndex == 1{//立即更新
                GYZUpdateVersionTool.goAppStore()
            }
        }else if tag == 102{
            if buttonIndex == 0{//立即更新
                GYZUpdateVersionTool.goAppStore()
            }
        }
        
    }
}
extension AppDelegate:RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate,RCIMUserInfoDataSource,RCIMGroupInfoDataSource{
    /*!
    IMKit连接状态的的监听器

    @param status  SDK与融云服务器的连接状态

    @discussion 如果您设置了IMKit消息监听之后，当SDK与融云服务器的连接状态发生变化时，会回调此方法。
    */
    func onRCIMConnectionStatusChanged(_ status: RCConnectionStatus) {
        if status == .ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT {//当前用户在其他设备上登录，此设备被踢下线
            GYZTool.removeUserInfo()
            goLogin()
            
            let alert = UIAlertView.init(title: "温馨提示", message: "您的帐号在别的设备上登录，您被迫下线！", delegate: self, cancelButtonTitle: "知道了")
            alert.show()
        }else if status == .ConnectionStatus_TOKEN_INCORRECT{//Token无效
            GYZTool.removeUserInfo()
            goLogin()
            
            let alert = UIAlertView.init(title: "温馨提示", message: "Token已过期，请重新登录", delegate: self, cancelButtonTitle: "确定")
            alert.show()
        }
    }
    func onRCIMCustomLocalNotification(_ message: RCMessage!, withSenderName senderName: String!) -> Bool {
        //群组通知不弹本地通知
        if message.content.isKind(of: RCGroupNotificationMessage.classForCoder()) {
            return true
        }
        return false
    }
    
    func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        
    }
    /*!
    *获取用户信息
    */
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        if !GYZTool.checkNetWork() {
            return
        }
        
        GYZNetWork.requestNetwork("Circle/Circle/getRongyunMemberInfo", parameters: ["member_id":userId!],  success: { (response) in
            
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["formdata"].dictionaryObject else { return }
                let dataModel = FSUserInfoModel.init(dict: data)
                let userInfo: RCUserInfo = RCUserInfo.init(userId: userId, name: dataModel.nick_name!, portrait: dataModel.avatar!)
                completion(userInfo)
            }
            
        }, failture: { (error) in
            GYZLog(error)
        })
    }
    /**
    *  获取群组信息
    */
    func getGroupInfo(withGroupId groupId: String!, completion: ((RCGroup?) -> Void)!) {
        if !GYZTool.checkNetWork() {
            return
        }
        
        GYZNetWork.requestNetwork("Circle/Circle/getRongyunCircleInfo", parameters: ["id":groupId!],  success: { (response) in
            
            GYZLog(response)
            
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                guard let data = response["data"]["formdata"].dictionaryObject else { return }
                let dataModel = FSIMCircleModel.init(dict: data)
                let groupInfo: RCGroup = RCGroup.init(groupId: groupId, groupName: dataModel.name!, portraitUri: dataModel.thumb!)
                completion(groupInfo)
            }
            
        }, failture: { (error) in
            GYZLog(error)
        })
    }
}
