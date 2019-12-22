//
//  FSResetPwdVC.swift
//  fitsky
//  重置密码
//  Created by gouyz on 2019/7/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSResetPwdVC: GYZBaseVC {
    
    var phoneNum: String = ""
    /// 验证码
    var codeContent: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBgAlpha = 0
        self.navigationItem.title = "重置密码"
        self.view.backgroundColor = kBlueBackgroundColor
        
        
        setUpUI()
        
    }
    func setUpUI(){
        
        view.addSubview(rePwdInputView)
        view.addSubview(pwdInputView)
        view.addSubview(reSetBtn)
        
        pwdInputView.snp.makeConstraints { (make) in
            make.top.equalTo(kTitleAndStateHeight * 2)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(50)
        }
        rePwdInputView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(pwdInputView)
            make.top.equalTo(pwdInputView.snp.bottom).offset(kTitleHeight)
        }
        reSetBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(pwdInputView)
            make.top.equalTo(rePwdInputView.snp.bottom).offset(kTitleHeight)
        }
    }
    
    /// 密码
    lazy var pwdInputView: GYZLoginInputView = {
        let phoneView = GYZLoginInputView.init(iconName: "icon_login_pwd",isPwd:true)
        
        phoneView.borderColor = kWhiteColor
        phoneView.cornerRadius = kCornerRadius
        phoneView.borderWidth = klineWidth
        phoneView.backgroundColor = kBlueBackgroundColor
        
        phoneView.textFiled.attributedPlaceholder = NSAttributedString.init(string: "输入新密码", attributes: [NSAttributedString.Key.foregroundColor:kWhiteColor, NSAttributedString.Key.font: k15Font])
        
        return phoneView
        
    }()
    /// 再次确认密码
    lazy var rePwdInputView: GYZLoginInputView = {
        let phoneView = GYZLoginInputView.init(iconName: "icon_login_pwd",isPwd:true)
        
        phoneView.borderColor = kWhiteColor
        phoneView.cornerRadius = kCornerRadius
        phoneView.borderWidth = klineWidth
        phoneView.backgroundColor = kBlueBackgroundColor
        
        phoneView.textFiled.attributedPlaceholder = NSAttributedString.init(string: "再次确认密码", attributes: [NSAttributedString.Key.foregroundColor:kWhiteColor, NSAttributedString.Key.font: k15Font])
        
        return phoneView
        
    }()
    /// 立即重置按钮
    lazy var reSetBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("立即重置", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k18Font
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = kBtnClickBGColor
        btn.addTarget(self, action: #selector(clickedResetBtn), for: .touchUpInside)
        
        btn.cornerRadius = kCornerRadius
        
        return btn
    }()
    
    /// 立即重置按钮
    @objc func clickedResetBtn(){
        if pwdInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入新密码")
            return
        }
        if rePwdInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入新密码")
            return
        }else if pwdInputView.textFiled.text != rePwdInputView.textFiled.text {
            MBProgressHUD.showAutoDismissHUD(message: "两次输入密码不一致")
            return
        }
        requestResetPwd()
    }
    
    ///重置密码
    func requestResetPwd(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Login/forget", parameters: ["mobile":phoneNum,"new_password":pwdInputView.textFiled.text!,"re_password":rePwdInputView.textFiled.text!,"code":codeContent],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.goPwdLoginVC()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    /// 密码登录
    func goPwdLoginVC(){
        for i in 0..<(navigationController?.viewControllers.count)!{
            
            if navigationController?.viewControllers[i].isKind(of: FSPwdLoginVC.self) == true {
                
                let vc = navigationController?.viewControllers[i] as! FSPwdLoginVC
                _ = navigationController?.popToViewController(vc, animated: true)
                
                break
            }
        }
    }
}
