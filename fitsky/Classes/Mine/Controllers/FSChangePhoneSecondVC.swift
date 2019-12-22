//
//  FSChangePhoneSecondVC.swift
//  fitsky
//
//  Created by gouyz on 2019/10/23.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSChangePhoneSecondVC: GYZWhiteNavBaseVC {
    
    /// 旧手机验证码
    var oldCode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "更换手机"
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("确定", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlueFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
    }
    
    func setUpUI(){
        view.addSubview(phoneView)
        view.addSubview(codeView)
        view.addSubview(codeLab)
        
        phoneView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.height.equalTo(50)
        }
        codeView.snp.makeConstraints { (make) in
            make.left.height.equalTo(phoneView)
            make.top.equalTo(phoneView.snp.bottom).offset(klineDoubleWidth)
            make.right.equalTo(codeLab.snp.left)
        }
        codeLab.snp.makeConstraints { (make) in
            make.height.top.equalTo(codeView)
            make.right.equalTo(view)
            make.width.equalTo(90)
        }
    }
    
    lazy var phoneView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "新手机号", placeHolder: "请输入新手机号")
        nView.desLab.textColor = kGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        
        return nView
    }()
    lazy var codeView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "输入验证码", placeHolder: "请输入验证码")
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
    
    
    /// 确定
    @objc func onClickRightBtn(){
        if phoneView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入手机号")
            return
        }else if !phoneView.textFiled.text!.isMobileNumber(){
            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的手机号")
            return
        }
        if codeView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入验证码")
            return
        }
        requestModifyPhone()
    }
    //修改手机号
    func requestModifyPhone(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Setting/editMobile", parameters: ["new_mobile":phoneView.textFiled.text!,"code":codeView.textFiled.text!,"old_code":oldCode],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
        
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dealBack()
            
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    func dealBack(){
        GYZTool.removeUserInfo()
        KeyWindow.rootViewController = GYZBaseNavigationVC(rootViewController: FSLoginVC())
    }
    /// 获取验证码
    @objc func clickedCodeBtn(){
        if phoneView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入手机号")
            return
        }else if !phoneView.textFiled.text!.isMobileNumber(){
            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的手机号")
            return
        }
        
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
        GYZNetWork.requestNetwork("Message/Sms/sendSMS", parameters: ["mobile":phoneView.textFiled.text!,"sms_type":6],  success: { (response) in
            
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
}
