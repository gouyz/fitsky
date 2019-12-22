//
//  FSForgetPwdPhoneVC.swift
//  fitsky
//  忘记密码 输入手机号
//  Created by gouyz on 2019/7/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSForgetPwdPhoneVC: GYZBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        navBarBgAlpha = 0
        self.navigationItem.title = "忘记密码"
        self.view.backgroundColor = kBlueBackgroundColor
        
        
        setUpUI()
        
    }
    func setUpUI(){
        
        view.addSubview(phoneInputView)
        view.addSubview(nextBtn)
        
        phoneInputView.snp.makeConstraints { (make) in
            make.top.equalTo(kTitleAndStateHeight * 2)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(50)
        }
        nextBtn.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(phoneInputView)
            make.top.equalTo(phoneInputView.snp.bottom).offset(50)
        }
    }
    
    /// 手机号
    lazy var phoneInputView: GYZLoginInputView = {
        let phoneView = GYZLoginInputView.init(iconName: "app_icon_phone", keyType: .numberPad)
        
        phoneView.borderColor = kWhiteColor
        phoneView.cornerRadius = kCornerRadius
        phoneView.borderWidth = klineWidth
        phoneView.backgroundColor = kBlueBackgroundColor
        
        phoneView.textFiled.attributedPlaceholder = NSAttributedString.init(string: "输入你的手机号码", attributes: [NSAttributedString.Key.foregroundColor:kWhiteColor, NSAttributedString.Key.font: k15Font])
        
        return phoneView
        
    }()
    
    
    /// 下一步按钮
    lazy var nextBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("下一步", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k18Font
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = kBtnClickBGColor
        btn.addTarget(self, action: #selector(clickedNextBtn), for: .touchUpInside)
        
        btn.cornerRadius = kCornerRadius
        
        return btn
    }()
    
    /// 下一步按钮
    @objc func clickedNextBtn(){
        if phoneInputView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入手机号")
            return
        }else if !phoneInputView.textFiled.text!.isMobileNumber(){
            MBProgressHUD.showAutoDismissHUD(message: "请输入正确的手机号")
            return
        }
        
        requestCode()
    }
    func goCodeVC(){
        let vc = FSForgetPwdCodeVC()
        vc.phoneNum = phoneInputView.textFiled.text!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///获取验证码
    func requestCode(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "获取中...")
        
        GYZNetWork.requestNetwork("Message/Sms/sendSMS", parameters: ["mobile":phoneInputView.textFiled.text!,"sms_type":3],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.goCodeVC()
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }

}
