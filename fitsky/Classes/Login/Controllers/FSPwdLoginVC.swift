//
//  FSPwdLoginVC.swift
//  fitsky
//  密码登录
//  Created by gouyz on 2019/7/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSPwdLoginVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        navBarBgAlpha = 0
        self.navigationItem.title = "密码登录"
        self.view.backgroundColor = kBlueBackgroundColor
        
        
        setUpUI()
        
    }
    func setUpUI(){
        
        view.addSubview(phoneInputView)
        view.addSubview(forgetPwdLab)
        view.addSubview(pwdInputView)
        view.addSubview(loginBtn)
        
        phoneInputView.snp.makeConstraints { (make) in
            make.top.equalTo(kTitleAndStateHeight * 2)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(50)
        }
        pwdInputView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(phoneInputView)
            make.top.equalTo(phoneInputView.snp.bottom).offset(30)
        }
        forgetPwdLab.snp.makeConstraints { (make) in
            make.right.equalTo(phoneInputView)
            make.top.equalTo(pwdInputView.snp.bottom).offset(5)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(phoneInputView)
            make.top.equalTo(forgetPwdLab.snp.bottom).offset(30)
        }
    }
    
    /// 手机号
    lazy var phoneInputView: GYZLoginInputView = {
        let phoneView = GYZLoginInputView.init(iconName: "app_icon_phone", keyType: .numberPad)
        
        phoneView.borderColor = kWhiteColor
        phoneView.cornerRadius = kCornerRadius
        phoneView.borderWidth = klineWidth
        phoneView.backgroundColor = kBlueBackgroundColor
        
        phoneView.textFiled.attributedPlaceholder = NSAttributedString.init(string: "输入你的帐号", attributes: [NSAttributedString.Key.foregroundColor:kWhiteColor, NSAttributedString.Key.font: k15Font])
        
        return phoneView
        
    }()
    
    /// 密码
    lazy var pwdInputView: GYZLoginInputView = {
        let phoneView = GYZLoginInputView.init(iconName: "icon_login_pwd",isPwd:true)
        
        phoneView.borderColor = kWhiteColor
        phoneView.cornerRadius = kCornerRadius
        phoneView.borderWidth = klineWidth
        phoneView.backgroundColor = kBlueBackgroundColor
        
        phoneView.textFiled.attributedPlaceholder = NSAttributedString.init(string: "请输入密码", attributes: [NSAttributedString.Key.foregroundColor:kWhiteColor, NSAttributedString.Key.font: k15Font])
        
        return phoneView
        
    }()
    /// 忘记密码？
    lazy var forgetPwdLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k13Font
        lab.textAlignment = .right
        lab.text = "忘记密码？"
        // MARK: 关闭点击效果 默认是开启的
        lab.enabledTapEffect = false
        lab.addOnClickListener(target: self, action: #selector(onClickedForgetPwd))
        
        return lab
    }()
    /// 立即登录按钮
    lazy var loginBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("立即登录", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k18Font
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = kBtnClickBGColor
        btn.addTarget(self, action: #selector(clickedLoginBtn), for: .touchUpInside)
        
        btn.cornerRadius = kCornerRadius
        
        return btn
    }()
    
    /// 忘记密码
    @objc func onClickedForgetPwd(){
        let vc = FSForgetPwdPhoneVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    /// 立即登录按钮
    @objc func clickedLoginBtn(){
        if phoneInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入手机号")
            return
        }else if !phoneInputView.textFiled.text!.isMobileNumber(){
            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的手机号")
            return
        }
        
        if pwdInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入密码")
            return
        }
        requestLogin()
    }
    
    ///密码登录
    func requestLogin(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "登录中...")
        
        GYZNetWork.requestNetwork("Member/Login/login", parameters: ["mobile":phoneInputView.textFiled.text!,"password":pwdInputView.textFiled.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                userDefaults.set(true, forKey: kIsLoginTagKey)//是否登录标识
                userDefaults.set(data["token"].stringValue, forKey: "token")
                userDefaults.set(data["member_type"].stringValue, forKey: kMemberTypeKey)
                weakSelf?.requestPushMemberClientID()
                weakSelf?.requestMemberInfo()
                KeyWindow.rootViewController = GYZMainTabBarVC()
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
