//
//  FSFeedBackVC.swift
//  fitsky
//  反馈
//  Created by gouyz on 2019/10/26.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSFeedBackVC: GYZWhiteNavBaseVC {
    
    ///txtView 提示文字
    let placeHolder = "请输入遇到的问题与建议…"
    var content: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "反馈"
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("提交", for: .normal)
        rightBtn.titleLabel?.font = k13Font
        rightBtn.setTitleColor(kBlueFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
        
        contentTxtView.delegate = self
        contentTxtView.text = placeHolder
    }
    
    func setUpUI(){
        view.addSubview(bgView)
        bgView.addSubview(contentTxtView)
        view.addSubview(emailView)
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.height.equalTo(150)
        }
        contentTxtView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kMargin)
            make.bottom.equalTo(-kMargin)
        }
        
        emailView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(bgView.snp.bottom).offset(kMargin)
            make.height.equalTo(50)
        }
    }
    
    lazy var bgView: UIView = {
       let bgview = UIView()
        bgview.backgroundColor = kWhiteColor
        
        return bgview
    }()
    
    /// 要做的事
    lazy var contentTxtView: UITextView = {
        
        let txtView = UITextView()
        txtView.font = k15Font
        txtView.textColor = kHeightGaryFontColor
        
        return txtView
    }()
    
    lazy var emailView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "联系邮箱", placeHolder: "选填，便于我们更快的联系你")
        nView.desLab.textColor = kGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        
        return nView
    }()
    
    /// 提交
    @objc func onClickRightBtn(){
        if contentTxtView.text.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入遇到的问题与建议…")
            return
        }
        
        requestFeedBack()
    }
    
    /// 帮助与关于-反馈
    func requestFeedBack(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Member/Member/feedback", parameters: ["content":contentTxtView.text!,"email":emailView.textFiled.text ?? ""],  success: { (response) in
            
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
extension FSFeedBackVC : UITextViewDelegate{
    ///MARK UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let text = textView.text
        if text == placeHolder {
            textView.text = ""
            textView.textColor = kGaryFontColor
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = kHeightGaryFontColor
        }
    }
}
