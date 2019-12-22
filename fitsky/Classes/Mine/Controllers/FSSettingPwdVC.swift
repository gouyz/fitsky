//
//  FSSettingPwdVC.swift
//  fitsky
//  设置密码
//  Created by gouyz on 2019/10/23.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSSettingPwdVC: GYZWhiteNavBaseVC {
    
    /// 选择结果回调
    var resultBlock:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "设置密码"
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
    }
    
    func setUpUI(){
        view.addSubview(newPwdView)
        view.addSubview(pwdView)
        view.addSubview(desLab)
        
        newPwdView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.height.equalTo(50)
        }
        pwdView.snp.makeConstraints { (make) in
            make.left.height.right.equalTo(newPwdView)
            make.top.equalTo(newPwdView.snp.bottom).offset(klineDoubleWidth)
        }
        desLab.snp.makeConstraints { (make) in
            make.top.equalTo(pwdView.snp.bottom)
            make.right.equalTo(-kMargin)
            make.left.equalTo(kMargin)
            make.height.equalTo(kTitleHeight)
        }
    }
    
    lazy var newPwdView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "新密码", placeHolder: "请输入新密码")
        nView.desLab.textColor = kGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        nView.textFiled.isSecureTextEntry = true
        
        return nView
    }()
    lazy var pwdView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "确认密码", placeHolder: "再次确认密码")
        nView.desLab.textColor = kGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        nView.textFiled.isSecureTextEntry = true
        
        return nView
    }()
    
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kHeightGaryFontColor
        lab.text = "6-10位密码、数字或字母"
        
        return lab
    }()
    
    
    /// 完成
    @objc func onClickRightBtn(){
        if newPwdView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入新密码")
            return
        }else if newPwdView.textFiled.text?.count < 6 || newPwdView.textFiled.text?.count > 10 {
            MBProgressHUD.showAutoDismissHUD(message: "请输入6-10位密码")
            return
        }
        if pwdView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入确认密码")
            return
        }
        if pwdView.textFiled.text != newPwdView.textFiled.text {
            MBProgressHUD.showAutoDismissHUD(message: "确认密码与新密码不一致")
            return
        }
        requestModifyPwd()
    }
    
    //设置密码
    func requestModifyPwd(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Setting/setPassword", parameters: ["new_password":newPwdView.textFiled.text!,"re_password":pwdView.textFiled.text!],  success: { (response) in
            
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
        if resultBlock != nil {
            resultBlock!()
        }
        clickedBackBtn()
    }
}
