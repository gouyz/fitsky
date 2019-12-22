//
//  FSForgetPwdCodeVC.swift
//  fitsky
//
//  Created by gouyz on 2019/7/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import CRBoxInputView
import MBProgressHUD

class FSForgetPwdCodeVC: GYZBaseVC {

    var phoneNum: String = ""
    /// 是否是手机号验证码登录
    var isPhoneLogin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBgAlpha = 0
        self.view.backgroundColor = kBlueBackgroundColor
        
        setUIUp()
        
        if isPhoneLogin {
            nextBtn.setTitle("确定", for: .normal)
        }
        
        codeInputView.textDidChangeblock = {[weak self] (text,isFinished) in

            if text?.count == 4 {
                self?.requestData()
            }
        }
        codeBtn.startSMSWithDuration(duration: 60)
    }
    
    func setUIUp(){
        view.addSubview(desLab)
        view.addSubview(desCodeLab)
        view.addSubview(desLab1)
        view.addSubview(codeBtn)
        view.addSubview(codeInputView)
        view.addSubview(nextBtn)
        
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(30 + kTitleAndStateHeight)
            make.right.equalTo(-30)
            make.height.equalTo(30)
        }
        desCodeLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(desLab)
            make.top.equalTo(desLab.snp.bottom)
            make.height.equalTo(20)
        }
        desLab1.snp.makeConstraints { (make) in
            make.left.equalTo(desLab)
            make.right.equalTo(codeBtn)
            make.top.equalTo(desCodeLab.snp.bottom).offset(50)
            make.height.equalTo(codeBtn)
        }
        codeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(desLab)
            make.top.equalTo(desLab1)
            make.size.equalTo(CGSize.init(width: 80, height: 30))
        }
        codeInputView.snp.makeConstraints { (make) in
            make.left.right.equalTo(desLab)
            make.height.equalTo(kTitleHeight)
            make.top.equalTo(codeBtn.snp.bottom).offset(kTitleHeight)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(desLab)
            make.top.equalTo(codeInputView.snp.bottom).offset(kTitleHeight)
            make.height.equalTo(kUIButtonHeight)
        }
        
    }
    
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k18Font
        lab.text = "请输入验证码"
        
        return lab
    }()
    ///
    lazy var desCodeLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k13Font
        lab.text = "短信验证码已发送至 +86 \(phoneNum.replacePhone())"
        
        return lab
    }()
    ///
    lazy var desLab1 : UILabel = {
        let lab = UILabel()
        lab.textColor = kWhiteColor
        lab.font = k13Font
        lab.text = "四位验证码"
        
        return lab
    }()
    /// 获取验证码按钮
    lazy var codeBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        btn.titleLabel?.font = k13Font
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor.ColorHexWithAlpha("#ffffff", alpha: 0.5)
        btn.addTarget(self, action: #selector(clickedCodeBtn), for: .touchUpInside)
        
        btn.cornerRadius = kCornerRadius
        
        return btn
    }()
    /// 验证码输入框
    lazy var codeInputView: CRBoxInputView = {
        let boxInputView = CRBoxInputView()
        let cellProperty = CRBoxInputCellProperty()
        cellProperty.cellBgColorNormal = UIColor.ColorHexWithAlpha("#ffffff", alpha: 0.4)
        cellProperty.cellBgColorSelected = UIColor.ColorHexWithAlpha("#ffffff", alpha: 0.4)
        cellProperty.cellBgColorFilled = UIColor.ColorHexWithAlpha("#ffffff", alpha: 0.4)
        cellProperty.borderWidth = 0
        cellProperty.cellFont = k15Font
        cellProperty.cellTextColor = kHeightGaryFontColor
        cellProperty.cornerRadius = kCornerRadius
        
        boxInputView.boxFlowLayout?.itemSize = CGSize.init(width: kTitleHeight, height: kTitleHeight)
        boxInputView.customCellProperty = cellProperty
        boxInputView.loadAndPrepare(withBeginEdit: false)
        
        if #available(iOS 12.0, *){
            boxInputView.textContentType = UITextContentType.oneTimeCode
        }
        
        return boxInputView
    }()
    
    /// 下一步按钮
    lazy var nextBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("下一步", for: .normal)
        btn.setTitleColor(kOrangeFontColor, for: .normal)
        btn.titleLabel?.font = k18Font
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = kWhiteColor
        btn.addTarget(self, action: #selector(clickedNextBtn), for: .touchUpInside)
        
        btn.cornerRadius = kCornerRadius
        
        return btn
    }()
    
    /// 获取验证码按钮
    @objc func clickedCodeBtn(){
        requestCode()
    }
    
    /// 下一步按钮
    @objc func clickedNextBtn(){
        if codeInputView.textValue == nil || codeInputView.textValue!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入验证码")
            return
        }else if codeInputView.textValue?.count != 4 {
            MBProgressHUD.showAutoDismissHUD(message: "验证码输入不全")
            return
        }
        requestData()
        
    }
    func requestData(){
        if isPhoneLogin {// 手机号登录
            requestCodeLogin()
        }else{
            requestVerifyCode()
        }
    }
    /// 设置密码
    func goResetPwdVC(){
        let vc = FSResetPwdVC()
        vc.codeContent = codeInputView.textValue!
        vc.phoneNum = self.phoneNum
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///获取验证码
    func requestCode(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "获取中...")
        
        GYZNetWork.requestNetwork("Message/Sms/sendSMS", parameters: ["mobile":phoneNum,"sms_type":(isPhoneLogin ? 1 : 3)],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    ///忘记密码验证码校验
    func requestVerifyCode(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "获取中...")
        
        GYZNetWork.requestNetwork("Message/Sms/forgetVerifyCode", parameters: ["mobile":phoneNum,"code":codeInputView.textValue!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.goResetPwdVC()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    ///验证码登录
    func requestCodeLogin(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "登录中...")
        
        GYZNetWork.requestNetwork("Member/Login/register", parameters: ["mobile":phoneNum,"code":codeInputView.textValue!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                let data = response["data"]
                userDefaults.set(true, forKey: kIsLoginTagKey)//是否登录标识
                userDefaults.set(data["token"].stringValue, forKey: "token")
                userDefaults.set(data["member_type"].stringValue, forKey: kMemberTypeKey)
                weakSelf?.requestPushMemberClientID()
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
