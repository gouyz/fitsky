//
//  FSChangePwdVC.swift
//  fitsky
//  更改密码
//  Created by gouyz on 2019/10/24.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSChangePwdVC: GYZWhiteNavBaseVC {
    
    var mobile: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "更改密码"
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("确认", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
    }
    
    func setUpUI(){
        view.addSubview(pwdView)
        view.addSubview(codeView)
        view.addSubview(codeLab)
        view.addSubview(desLab)
        
        codeView.snp.makeConstraints { (make) in
            make.left.height.equalTo(pwdView)
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.right.equalTo(codeLab.snp.left)
        }
        codeLab.snp.makeConstraints { (make) in
            make.height.top.equalTo(codeView)
            make.right.equalTo(view)
            make.width.equalTo(90)
        }
        pwdView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(codeView.snp.bottom).offset(klineDoubleWidth)
            make.height.equalTo(50)
        }
        desLab.snp.makeConstraints { (make) in
            make.top.equalTo(pwdView.snp.bottom)
            make.right.equalTo(-kMargin)
            make.left.equalTo(kMargin)
            make.height.equalTo(kTitleHeight)
        }
    }
    
    lazy var pwdView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "新密码", placeHolder: "请输入新密码")
        nView.desLab.textColor = kGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        nView.textFiled.isSecureTextEntry = true
        
        return nView
    }()
    lazy var codeView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "验证码", placeHolder: "请输入验证码")
        nView.desLab.textColor = kGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        
        return nView
    }()
    
    /// 获取验证码
    lazy var codeLab : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.setTitle("获取验证码", for: .normal)
        btn.titleLabel?.font = k12Font
        btn.backgroundColor = kWhiteColor
        
        btn.addTarget(self, action: #selector(clickedCodeBtn), for: .touchUpInside)
        
        return btn
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "6-10位密码、数字或字母"
        
        return lab
    }()
    
    
    /// 确定
    @objc func onClickRightBtn(){
        if codeView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入验证码")
            return
        }
        if pwdView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入新密码")
            return
        }else if pwdView.textFiled.text?.count < 6 || pwdView.textFiled.text?.count > 10 {
            MBProgressHUD.showAutoDismissHUD(message: "请输入6-10位密码")
            return
        }
        
        requestModifyPwd()
    }
    /// 获取验证码按钮
    @objc func clickedCodeBtn(){
        requestCode()
    }
    ///获取验证码
    func requestCode(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "获取中...")
        /// 1-登录注册 2-绑定 3-忘记密码 4-修改密码 5-更换手机验证 6-更换新手机
        GYZNetWork.requestNetwork("Message/Sms/sendSMS", parameters: ["mobile":mobile,"sms_type":4],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.codeLab.startSMSWithDuration(duration: 60)
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    //修改密码
    func requestModifyPwd(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Setting/editPassword", parameters: ["new_password":pwdView.textFiled.text!,"code":codeView.textFiled.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
        
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.clickedBackBtn()
            
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
