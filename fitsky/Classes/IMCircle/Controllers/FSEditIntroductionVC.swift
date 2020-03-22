//
//  FSEditIntroductionVC.swift
//  fitsky
//  社圈简介
//  Created by gouyz on 2020/3/8.
//  Copyright © 2020 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSEditIntroductionVC: GYZWhiteNavBaseVC {
    
    /// 选择结果回调
    var resultBlock:((_ brief: String) -> Void)?
    
    //// 最大字数
    var contentMaxCount: Int = 120
    var circleId: String = ""
    ///txtView 提示文字
    let placeHolder = "填写简介"
    var content: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "社圈简介"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        view.addSubview(bgView)
        bgView.addSubview(contentTxtView)
        view.addSubview(fontCountLab)
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(kTitleAndStateHeight + kMargin)
            make.height.equalTo(100)
        }
        contentTxtView.snp.makeConstraints { (make) in
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
        
        contentTxtView.delegate = self
        
        if content.count > 0 {
            contentTxtView.text = content
            fontCountLab.text =  "\(content.count)/\(contentMaxCount)字"
            rightBtn.isEnabled = true
        }else{
            contentTxtView.text = placeHolder
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
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        
        return rightBtn
    }()
    lazy var bgView: UIView = {
        let bgview = UIView()
        bgview.backgroundColor = kWhiteColor
        
        return bgview
    }()
    
    ///
    lazy var contentTxtView: UITextView = {
        
        let txtView = UITextView()
        txtView.font = k15Font
        txtView.textColor = kHeightGaryFontColor
        
        return txtView
    }()
    /// 限制字数
    lazy var fontCountLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .right
        lab.text = "0/\(contentMaxCount)字"
        
        return lab
    }()
    /// 完成
    @objc func onClickRightBtn(){
        requestModifyBrief()
    }
    //修改简介
    func requestModifyBrief(){
        if !GYZTool.checkNetWork() {
            return
        }

        weak var weakSelf = self
        createHUD(message: "加载中...")

        GYZNetWork.requestNetwork("Circle/Circle/editBrief", parameters: ["brief":content,"id":circleId],  success: { (response) in

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
            resultBlock!(content)
        }
        clickedBackBtn()
    }
}
extension FSEditIntroductionVC : UITextViewDelegate{
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
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count > contentMaxCount - 20 {
            
            //获得已输出字数与正输入字母数
            let selectRange = textView.markedTextRange
            
            //获取高亮部分 － 如果有联想词则解包成功
            if let selectRange =   selectRange {
                let position =  textView.position(from: (selectRange.start), offset: 0)
                if (position != nil) {
                    return
                }
            }
            
            let textContent = textView.text
            let textNum = textContent?.count
            
            //截取20个字
            if textNum! > contentMaxCount {
                let str = textContent?.subString(start: 0, length: contentMaxCount)
                textView.text = str
            }
        }
        
        content = textView.text
        self.fontCountLab.text =  "\(textView.text.count)/\(contentMaxCount)字"
        if content.count > 0 {
            rightBtn.isEnabled = true
        }else {
            rightBtn.isEnabled = false
        }
    }
}
