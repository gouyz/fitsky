//
//  FSModifyEmailVC.swift
//  fitsky
//  修改邮箱
//  Created by gouyz on 2019/10/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSModifyEmailVC: GYZWhiteNavBaseVC {
    
    /// 选择结果回调
    var resultBlock:((_ email: String) -> Void)?
    var email: String = ""
    /// 是否是场馆修改名称
    var isVenue: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "修改邮箱"
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlueFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        view.addSubview(bgView)
        bgView.addSubview(nicknameTxtFiled)
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.height.equalTo(50)
        }
        nicknameTxtFiled.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(bgView)
        }
        
        nicknameTxtFiled.text = email
    }
    lazy var bgView: UIView = {
        let bgview = UIView()
        bgview.backgroundColor = kWhiteColor
        
        return bgview
    }()
    
    /// 昵称
    lazy var nicknameTxtFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kGaryFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = "请输入邮箱"
        
        return textFiled
    }()
    /// 完成
    @objc func onClickRightBtn(){
        if nicknameTxtFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入邮箱")
            return
        }else if !nicknameTxtFiled.text!.isValidateEmail(){
            MBProgressHUD.showAutoDismissHUD(message: "邮箱格式不正确")
            return
        }
        if isVenue {
            requestModifyVueneProfileInfo()
        }else{
            requestModifyEmail()
        }
    }
    //修改邮箱
    func requestModifyEmail(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Member/email", parameters: ["email":nicknameTxtFiled.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dealData()
                
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    //修改场馆
    func requestModifyVueneProfileInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Admin/Store/edit", parameters: ["email":nicknameTxtFiled.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
        
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                weakSelf?.dealData()
            
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
    
    func dealData(){
        if resultBlock != nil {
            resultBlock!(nicknameTxtFiled.text!)
        }
        clickedBackBtn()
    }
}
