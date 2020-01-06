//
//  FSLoginVC.swift
//  fitsky
//  登录
//  Created by gouyz on 2019/7/12.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD
import AuthenticationServices

class FSLoginVC: GYZBaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBgAlpha = 0
        self.view.backgroundColor = kBlueBackgroundColor
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.setTitle("游客身份", for: .normal)
        leftBtn.titleLabel?.font = k13Font
        leftBtn.setTitleColor(kWhiteColor, for: .normal)
        leftBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        leftBtn.addTarget(self, action: #selector(onClickLeftBtn), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        leftBtn.sizeToFit() // 解决iOS11以下，显示不全
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("密码登录", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kWhiteColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        rightBtn.sizeToFit()
        
        setUpUI()
        
    }
    func setUpUI(){
        
        view.addSubview(logoImgView)
        view.addSubview(phoneInputView)
        view.addSubview(codeBtn)
        view.addSubview(desLab)
        view.addSubview(thirdDesLab)
        view.addSubview(qqBtn)
        view.addSubview(wechatBtn)
        
        if #available(iOS 13.0, *){
            view.addSubview(appleBtn)
        }
        //        view.addSubview(sinaBtn)
        
        logoImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(20 + kTitleAndStateHeight)
            make.size.equalTo(CGSize.init(width: 140, height: 46))
        }
        
        phoneInputView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(logoImgView.snp.bottom).offset(60)
            make.height.equalTo(kUIButtonHeight)
        }
        codeBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(phoneInputView)
            make.top.equalTo(phoneInputView.snp.bottom).offset(40)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(codeBtn)
            make.top.equalTo(codeBtn.snp.bottom).offset(kMargin)
            make.height.equalTo(20)
        }
        
        qqBtn.snp.makeConstraints { (make) in
            make.left.equalTo(codeBtn)
            make.bottom.equalTo(-60)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        wechatBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.size.equalTo(qqBtn)
        }
        //        sinaBtn.snp.makeConstraints { (make) in
        //            make.right.equalTo(codeBtn)
        //            make.bottom.size.equalTo(qqBtn)
        //        }
        thirdDesLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(desLab)
            make.bottom.equalTo(qqBtn.snp.top).offset(-kMargin)
        }
    }
    
    /// logo
    lazy var logoImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_logo_fitsky"))
    /// 手机号
    lazy var phoneInputView: GYZLoginInputView = {
        let phoneView = GYZLoginInputView.init(iconName: "app_icon_phone", keyType: .numberPad)
        
        phoneView.borderColor = kWhiteColor
        phoneView.cornerRadius = kCornerRadius
        phoneView.borderWidth = klineWidth
        phoneView.backgroundColor = kBlueBackgroundColor
        
        phoneView.textFiled.attributedPlaceholder = NSAttributedString.init(string: "请输入手机号", attributes: [NSAttributedString.Key.foregroundColor:kWhiteColor, NSAttributedString.Key.font: k15Font])
        
        return phoneView
        
    }()
    /// 获取验证码
    lazy var codeBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.font = k18Font
        btn.backgroundColor = kBtnClickBGColor
        btn.cornerRadius = kCornerRadius
        
        btn.addTarget(self, action: #selector(clickedGetCodeBtn), for: .touchUpInside)
        
        return btn
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k13Font
        lab.textAlignment = .center
        lab.text = "未注册手机验证后自动登录"
        
        return lab
    }()
    ///
    lazy var thirdDesLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k13Font
        lab.textAlignment = .center
        lab.text = "第三方登录"
        lab.isHidden = true
        
        return lab
    }()
    /// 苹果登录
    @available(iOS 13.0, *)
    lazy var appleBtn: ASAuthorizationAppleIDButton = {
        let btn = ASAuthorizationAppleIDButton.init(authorizationButtonType: ASAuthorizationAppleIDButton.ButtonType.signIn, authorizationButtonStyle: ASAuthorizationAppleIDButton.Style.white)
        btn.frame = CGRect.init(x: kScreenWidth - 160, y: kScreenHeight - 100, width: 130, height: 30)
        btn.tag = 104
        btn.addTarget(self, action: #selector(clickedThirdLoginBtn(sender:)), for: .touchUpInside)
        
        return btn
    }()
    
    /// qq登录
    lazy var qqBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_qq"), for: .normal)
        btn.backgroundColor = kBlueBackgroundColor
        btn.tag = 101
        
        btn.addTarget(self, action: #selector(clickedThirdLoginBtn(sender:)), for: .touchUpInside)
        //        btn.isHidden = true
        
        return btn
    }()
    /// 微信登录
    lazy var wechatBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_weixin"), for: .normal)
        btn.backgroundColor = kBlueBackgroundColor
        btn.tag = 102
        
        btn.addTarget(self, action: #selector(clickedThirdLoginBtn(sender:)), for: .touchUpInside)
        //        btn.isHidden = true
        
        return btn
    }()
    /// 新浪登录
    lazy var sinaBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_weibo"), for: .normal)
        btn.backgroundColor = kBlueBackgroundColor
        btn.tag = 103
        
        btn.addTarget(self, action: #selector(clickedThirdLoginBtn(sender:)), for: .touchUpInside)
        
        return btn
    }()
    /// 游客身份
    @objc func onClickLeftBtn(){
        KeyWindow.rootViewController = GYZMainTabBarVC()
    }
    /// 密码登录
    @objc func onClickRightBtn(){
        let vc = FSPwdLoginVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 获取验证码
    @objc func clickedGetCodeBtn(){
        if phoneInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入手机号")
            return
        }else if !phoneInputView.textFiled.text!.isMobileNumber(){
            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的手机号")
            return
        }
        
        requestCode()
    }
    
    /// 第三方登录
    @objc func clickedThirdLoginBtn(sender: UIButton){
        let tag = sender.tag
        if tag == 101 {/// qq登录
            qqLogin()
        }else if tag == 102 {/// 微信登录
            weChatLogin()
        }else if tag == 104 {/// apple登录
            if #available(iOS 13.0, *) {
                handleAuthAppleIDButtonPress()
            }
        }else{
        }
    }
    /// 微信登录
    func weChatLogin(){
        WXApiManager.shared.login(self, loginSuccess: {[unowned self] (code) in
            self.requestAccessToken(code)
        }) {
            MBProgressHUD.showAutoDismissHUD(message: "微信授权登录失败")
        }
    }
    /// qq登录
    func qqLogin(){
        GYZTencentShare.shared.login({[unowned self] (info) in
            GYZLog(info)
            self.requestThirdLogin(openId: info["uid"]! as! String, openType: "3", accessToken: nil, qqInfo: info)
            //            self.goBindVC()
        }) { (error) in
            MBProgressHUD.showAutoDismissHUD(message: error)
        }
    }
    /// 注册验证码
    func goRegisterCodeVC(){
        let vc = FSRegisterCodeVC()
        vc.phoneNum = phoneInputView.textFiled.text!
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 登录验证码
    func goLoginCodeVC(){
        let vc = FSForgetPwdCodeVC()
        vc.isPhoneLogin = true
        vc.phoneNum = phoneInputView.textFiled.text!
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 绑定手机号
    func goBindVC(openId:String,openType:String,name:String,header:String,sex:String){
        let vc = FSBindPhoneVC()
        vc.openId = openId
        vc.thirdType = openType
        vc.nickname = name
        vc.avatar = header
        vc.sex = sex
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///获取验证码
    func requestCode(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "获取中...")
        
        GYZNetWork.requestNetwork("Message/Sms/sendSMS", parameters: ["mobile":phoneInputView.textFiled.text!,"sms_type":1],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let isLogin: Int = response["data"]["is_login"].intValue
                if isLogin == 1{//0-注册 1-登录
                    weakSelf?.goLoginCodeVC()
                }else{
                    weakSelf?.goRegisterCodeVC()
                }
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func requestAccessToken(_ code: String) {
        // 第二步: 请求accessToken
        let urlStr = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(kWeChatAppID)&secret=\(kWeChatAppSecret)&code=\(code)&grant_type=authorization_code"
        
        let url = URL(string: urlStr)
        
        do {
            
            let responseData = try Data.init(contentsOf: url!, options: Data.ReadingOptions.alwaysMapped)
            
            let dic = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>
            
            guard dic != nil else {
                MBProgressHUD.showAutoDismissHUD(message: "获取授权信息异常")
                return
            }
            
            guard dic!["access_token"] != nil else {
                MBProgressHUD.showAutoDismissHUD(message: "获取授权信息异常")
                return
            }
            
            guard dic!["openid"] != nil else {
                MBProgressHUD.showAutoDismissHUD(message: "获取授权信息异常")
                return
            }
            self.requestThirdLogin(openId: dic!["openid"]! as! String, openType: "2", accessToken: dic!["access_token"]! as? String)
        } catch {
            MBProgressHUD.showAutoDismissHUD(message: "获取授权信息异常")
        }
    }
    // 根据获取到的accessToken来请求用户信息
    func requestUserInfo(_ accessToken: String, openID: String) {
        
        let urlStr = "https://api.weixin.qq.com/sns/userinfo?access_token=\(accessToken)&openid=\(openID)"
        
        let url = URL(string: urlStr)
        
        do {
            
            let responseData = try Data.init(contentsOf: url!, options: Data.ReadingOptions.alwaysMapped)
            
            let dic = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>
            
            guard dic != nil else {
                MBProgressHUD.showAutoDismissHUD(message: "获取授权信息异常")
                return
            }
            
            if let userInfo = dic {
                
                // 这个字典(dic)内包含了我们所请求回的相关用户信息
                GYZLog(userInfo)
                self.goBindVC(openId: openID, openType: "2", name: userInfo["nickname"] as! String, header: userInfo["headimgurl"] as! String, sex: "\(userInfo["sex"] as! Int)")
            }
        } catch {
            MBProgressHUD.showAutoDismissHUD(message: "获取授权信息异常")
        }
    }
    
    ///第三方登录
    func requestThirdLogin(openId:String,openType:String, accessToken: String? = nil ,qqInfo:[String:Any]? = nil,appleNickName:String = ""){
        phoneInputView.textFiled.resignFirstResponder()
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "登录中...")
        
        GYZNetWork.requestNetwork("Member/Login/thirdLogin", parameters: ["open_id":openId,"open_type":openType],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            //            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                userDefaults.set(true, forKey: kIsLoginTagKey)//是否登录标识
                userDefaults.set(data["token"].stringValue, forKey: "token")
                userDefaults.set(data["member_type"].stringValue, forKey: kMemberTypeKey)
                weakSelf?.requestPushMemberClientID()
                KeyWindow.rootViewController = GYZMainTabBarVC()
            }else if response["result"].intValue == 10001{//请求成功
                if openType == "2" {// 微信
                    // 根据获取到的accessToken来请求用户信息
                    weakSelf?.requestUserInfo(accessToken!, openID: openId)
                }else if openType == "3" {// QQ
                    var sex: String = "2"
                    let sexName:String = qqInfo!["sex"] as! String
                    if sexName == "男"{
                        sex  = "1"
                    }else if sexName == "女"{
                        sex  = "0"
                    }
                    weakSelf?.goBindVC(openId: openId, openType: openType, name: qqInfo!["nickName"] as! String, header: qqInfo!["advatarStr"] as! String, sex: sex)
                }else if openType == "5" {// apple
                    weakSelf?.goBindVC(openId: openId, openType: openType, name: appleNickName, header: "", sex: "2")
                }
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///获取消息推送 cid
    func requestPushMemberClientID(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        let clientId: String = GeTuiSdk.clientId()
        GYZNetWork.requestNetwork("Member/MemberClient/add",parameters: ["client_id":clientId,"client_type":"1"],  success: { (response) in
            
            GYZLog(response)
            
        }, failture: { (error) in
            
            GYZLog(error)
        })
    }
}


@available(iOS 13.0, *)
extension FSLoginVC: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
    
    /// 按下按钮->处理苹果ID认证
    func handleAuthAppleIDButtonPress(){
        //基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        // 创建请求
        let request = ASAuthorizationAppleIDProvider.init().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        
        let authController = ASAuthorizationController(authorizationRequests: [request])
        
        authController.delegate = self
        
        authController.presentationContextProvider = self
        
        authController.performRequests()//启动授权
    }
    /// ASAuthorizationControllerPresentationContextProviding用于返回弹出请求框的window，一般返回当前视图window即可
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
    /// 授权成功
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        /// 苹果ID凭证有效
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            
            let fullName = appleIDCredential.fullName
            
            let email = appleIDCredential.email
            
            // 存储userIdkeychain.
            
            self.requestThirdLogin(openId: userIdentifier, openType: "5", accessToken: nil, qqInfo: nil,appleNickName: (fullName?.givenName)!)
//            do {// 保存到钥匙串
//
//                try KeychainItem(service: "com.example.apple-samplecode.juice", account: "userIdentifier").saveItem(userIdentifier)
//
//            } catch {
//
//                print("Unable to save userIdentifier to keychain.")
//
//            }
//
//            // 登录成功后隐藏登录页，并在结果页填充数据
//
//            if let viewController = self.presentingViewController as? ResultViewController {
//
//                DispatchQueue.main.async {
//
//                    viewController.userIdentifierLabel.text = userIdentifier
//
//                    if let givenName = fullName?.givenName {
//
//                        viewController.givenNameLabel.text = givenName
//
//                    }
//
//                    if let familyName = fullName?.familyName {
//
//                        viewController.familyNameLabel.text = familyName
//
//                    }
//
//                    if let email = email {
//
//                        viewController.emailLabel.text = email
//
//                    }
//
//                    self.dismiss(animated: true, completion: nil)
//
//                }
//
//            }
            
        }
            
            /// 密码凭证有效
            
        else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            
            // 用已有的钥匙串登录
            
            let username = passwordCredential.user
            
            let password = passwordCredential.password
            self.requestThirdLogin(openId: username, openType: "5", accessToken: nil, qqInfo: nil,appleNickName: "")
            
        }
        
    }
    /// 授权失败
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        
        var errorMsg = "未知"
        
        switch (error) {///
            
        case ASAuthorizationError.canceled:
            
            errorMsg = "用户取消了授权请求"
            
            break
            
        case ASAuthorizationError.failed:
            
            errorMsg = "授权请求失败"
            
            break
            
        case ASAuthorizationError.invalidResponse:
            
            errorMsg = "授权请求响应无效"
            
            break
            
        case ASAuthorizationError.notHandled:
            
            errorMsg = "未能处理授权请求"
            
            break
            
        case ASAuthorizationError.unknown:
            
            errorMsg = "授权请求失败，原因未知"
            
            break
            
        default:
            
            break
            
        }
        
        MBProgressHUD.showAutoDismissHUD(message: errorMsg)
    }
}
