//
//  FSModifyDaiHaoVC.swift
//  fitsky
//  代号
//  Created by gouyz on 2020/3/7.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSModifyDaiHaoVC: GYZWhiteNavBaseVC {
    
    /// 选择结果回调
    var resultBlock:((_ nickName: String) -> Void)?
    //// 最大字数
    var contentMaxCount: Int = 10
    var circleId: String = ""
    var nickName: String = ""
    var placeholder: String = "请输入社圈名称"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "修改社圈名称"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        view.addSubview(bgView)
        bgView.addSubview(desLab)
        bgView.addSubview(nicknameTxtFiled)
        view.addSubview(fontCountLab)
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.height.equalTo(50)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.bottom.equalTo(nicknameTxtFiled)
            make.width.equalTo(80)
        }
        nicknameTxtFiled.snp.makeConstraints { (make) in
            make.left.equalTo(desLab.snp.right)
            make.right.equalTo(-kMargin)
            make.top.bottom.equalTo(bgView)
        }
        fontCountLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(bgView.snp.bottom)
            make.height.equalTo(30)
        }
        
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
        rightBtn.setTitle("确定", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kHeightGaryFontColor, for: .disabled)
        rightBtn.setTitleColor(kBlueFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        
        return rightBtn
    }()
    lazy var bgView: UIView = {
        let bgview = UIView()
        bgview.backgroundColor = kWhiteColor
        
        return bgview
    }()
    ///
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        lab.textColor = kGaryFontColor
        lab.text = "社圈名称"
        
        return lab
    }()
    /// 昵称
    lazy var nicknameTxtFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = UIFont.boldSystemFont(ofSize: 14)
        textFiled.textColor = kGaryFontColor
        textFiled.clearButtonMode = .whileEditing
        textFiled.placeholder = placeholder
        textFiled.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
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
        requestModifyNameInfo()
    }
    //修改昵称
    func requestModifyNameInfo(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Circle/Circle/editName", parameters: ["name":nickName,"id":circleId],  success: { (response) in
            
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
            if textField.text?.count > contentMaxCount {
                textField.text = textField.text?.subString(start: 0, length: contentMaxCount)
            }
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
