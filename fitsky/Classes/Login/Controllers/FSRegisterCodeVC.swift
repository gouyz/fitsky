//
//  FSRegisterCodeVC.swift
//  fitsky
//  注册验证码页面
//  Created by gouyz on 2019/7/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import CRBoxInputView
import MBProgressHUD

class FSRegisterCodeVC: GYZBaseVC {
    var phoneNum: String = ""
    let ruleContent: String = "我已阅读并同意\nFitSky《注册用户协议》与《隐私协议》"

    override func viewDidLoad() {
        super.viewDidLoad()

        navBarBgAlpha = 0
        self.view.backgroundColor = kBlueBackgroundColor
        
        setUIUp()
        
        ruleLab.yb_addAttributeTapAction(with: ["《注册用户协议》","《隐私协议》"]) {[unowned self] (label, string, range, index) in
            if index == 0{//用户协议
                self.goWebVC(method: "News/Home/userAgreement")
            }else{//隐私协议
                self.goWebVC(method: "News/Home/privacyAgreement")
            }
        }
//        ruleLab.yb_addAttributeTapAction(["《注册用户协议》","《隐私协议》"]) {[unowned self] (string, range, index) in
//            print("点击了\(string)标签 - {\(range.location) , \(range.length)} - \(index)")
//            if index == 0{//用户协议
//                self.goWebVC(method: "News/Home/userAgreement")
//            }else{//隐私协议
//                self.goWebVC(method: "News/Home/privacyAgreement")
//            }
//        }
//        codeInputView.textDidChangeblock = {[weak self] (text,isFinished) in
//            
//            GYZLog("输入了\(text ?? "")")
//        }
        codeBtn.startSMSWithDuration(duration: 60)
    }
    
    func setUIUp(){
        view.addSubview(desLab)
        view.addSubview(desCodeLab)
        view.addSubview(desLab1)
        view.addSubview(codeBtn)
        view.addSubview(codeInputView)
        view.addSubview(loginBtn)
        view.addSubview(checkImgView)
        view.addSubview(ruleLab)
        
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
        loginBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(desLab)
            make.top.equalTo(codeInputView.snp.bottom).offset(30)
            make.height.equalTo(kUIButtonHeight)
        }
        checkImgView.snp.makeConstraints { (make) in
            make.left.equalTo(desLab)
            make.top.equalTo(loginBtn.snp.bottom).offset(30)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        ruleLab.snp.makeConstraints { (make) in
            make.left.equalTo(checkImgView.snp.right).offset(3)
            make.top.equalTo(checkImgView)
            make.right.equalTo(loginBtn)
            make.height.equalTo(32)
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
        btn.setTitle("重新获取", for: .normal)
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
    
    /// 验证登录按钮
    lazy var loginBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("验证登录", for: .normal)
        btn.setTitleColor(kOrangeFontColor, for: .normal)
        btn.titleLabel?.font = k18Font
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = kWhiteColor
        btn.addTarget(self, action: #selector(clickedVerityLoginBtn), for: .touchUpInside)
        
        btn.cornerRadius = kCornerRadius
        
        return btn
    }()
    lazy var checkImgView: UIImageView = {
        let imgView = UIImageView.init(image: UIImage.init(named: "icon_check_normal"))
        imgView.highlightedImage = UIImage.init(named: "icon_check_selected")
        imgView.addOnClickListener(target: self, action: #selector(clickedCheckRule))
        
        return imgView
    }()
    lazy var ruleLab: UILabel = {
        let lab = UILabel()
        let attStr = NSMutableAttributedString.init(string: ruleContent)
        attStr.addAttribute(NSAttributedString.Key.font, value: k13Font, range: NSMakeRange(0, ruleContent.count))
       attStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kWhiteColor, range: NSMakeRange(0, ruleContent.count))
        attStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kWhiteColor, range: NSMakeRange(13, 8))
        attStr.addAttribute(NSAttributedString.Key.foregroundColor, value: kWhiteColor, range: NSMakeRange(22, 6))
        
        lab.attributedText = attStr
        /// 点击效果，关闭
        lab.enabledTapEffect = false
        lab.numberOfLines = 0
        
        return lab
    }()
    /// 获取验证码按钮
    @objc func clickedCodeBtn(){
        requestCode()
    }
    
    /// 验证登录按钮
    @objc func clickedVerityLoginBtn(){
        if codeInputView.textValue == nil || codeInputView.textValue!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入验证码")
            return
        }else if codeInputView.textValue?.count != 4 {
            MBProgressHUD.showAutoDismissHUD(message: "验证码输入不全")
            return
        }
        if !checkImgView.isHighlighted {
            MBProgressHUD.showAutoDismissHUD(message: "请先阅读并同意FitSky《注册用户协议》与《隐私协议》")
            return
        }
        requestRegister()
    }
    
    /// 选择性别
    func goSexVC(){
        let vc = FSSexInfoVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 同意协议按钮
    @objc func clickedCheckRule(){
        checkImgView.isHighlighted = !checkImgView.isHighlighted
    }
    
    ///获取验证码
    func requestCode(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "获取中...")
        
        GYZNetWork.requestNetwork("Message/Sms/sendSMS", parameters: ["mobile":phoneNum,"sms_type":1],  success: { (response) in
            
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
    
    ///注册
    func requestRegister(){
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
                weakSelf?.goSexVC()
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
    /// webView
    func goWebVC(method: String){
        let vc = JSMWebViewVC()
        vc.method = method
        navigationController?.pushViewController(vc, animated: true)
    }
}
