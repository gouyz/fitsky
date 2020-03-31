//
//  FSModifyNickNameVC.swift
//  fitsky
//  修改昵称
//  Created by gouyz on 2019/10/17.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSModifyNickNameVC: GYZWhiteNavBaseVC {
    
    /// 选择结果回调
    var resultBlock:((_ nickName: String) -> Void)?
    //// 最大字数
    var contentMaxCount: Int = 10
    var nickName: String = ""
    /// 是否是场馆修改名称
    var isVenue: Bool = false
    var placeholder: String = "请输入昵称"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = isVenue ? "修改场馆名称" : "修改昵称"
        
//        let rightBtn = UIButton(type: .custom)
//        rightBtn.setTitle("完成", for: .normal)
//        rightBtn.titleLabel?.font = k13Font
//        rightBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
//        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
//        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        
        view.addSubview(bgView)
        bgView.addSubview(nicknameTxtFiled)
        view.addSubview(fontCountLab)
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
        fontCountLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(bgView.snp.bottom)
            make.height.equalTo(30)
        }
        nicknameTxtFiled.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        nicknameTxtFiled.text = nickName
        self.fontCountLab.text = "\(nickName.count)/\(contentMaxCount)"
        if nickName.count > 0 {
            rightBtn.isEnabled = true
        }else {
            rightBtn.isEnabled = false
        }
    }
    var rightBtn: UIButton = {
       let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("完成", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kHeightGaryFontColor, for: .disabled)
        rightBtn.setTitleColor(kBlueFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
//        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        
        return rightBtn
    }()
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
        textFiled.placeholder = placeholder
//        textFiled.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        return textFiled
    }()
    /// 限制字数
    lazy var fontCountLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .right
        lab.text = "0/\(contentMaxCount)"
        
        return lab
    }()
    /// 完成
    @objc func onClickRightBtn(){
        
        if nickName.count == 0 {
            MBProgressHUD.showAutoDismissHUD(message: placeholder)
            return
        }
        if isVenue {
            requestModifyVueneProfileInfo()
        }else{
            requestModifyProfileInfo()
        }
    }
    //修改昵称
    func requestModifyProfileInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Member/nickname", parameters: ["nick_name":nickName],  success: { (response) in
            
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
    //修改场馆名称
    func requestModifyVueneProfileInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Admin/Store/edit", parameters: ["store_name":nickName],  success: { (response) in
            
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
            resultBlock!(nickName)
        }
        clickedBackBtn()
    }
    
    @objc func textFieldDidChange(textField:UITextField){
        if textField == self.nicknameTxtFiled {
//            if textField.text?.count > contentMaxCount {
//                textField.text = textField.text?.subString(start: 0, length: contentMaxCount)
//            }
            if textField.text!.count > contentMaxCount - 10 {
                
                //获得已输出字数与正输入字母数
                let selectRange = textField.markedTextRange
                
                //获取高亮部分 － 如果有联想词则解包成功
                if let selectRange =   selectRange {
                    let position =  textField.position(from: (selectRange.start), offset: 0)
                    if (position != nil) {
                        return
                    }
                }
                
                let textContent = textField.text
                let textNum = textContent?.count
                
                //截取500个字
                if textNum! > contentMaxCount {
                    //                let index = textContent?.index((textContent?.startIndex)!, offsetBy: contentMaxCount)
                    let str = textContent?.subString(start: 0, length: contentMaxCount)
                    textField.text = str
                }
            }
            nickName = textField.text!
            self.fontCountLab.text = "\(nickName.count)/\(contentMaxCount)"
            if nickName.count > 0 {
                rightBtn.isEnabled = true
            }else {
                rightBtn.isEnabled = false
            }
        }
        
    }
}
