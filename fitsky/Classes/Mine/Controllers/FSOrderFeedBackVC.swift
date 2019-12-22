//
//  FSOrderFeedBackVC.swift
//  fitsky
//  订单反馈
//  Created by gouyz on 2019/11/18.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSOrderFeedBackVC: GYZWhiteNavBaseVC {
    
    /// 选择结果回调
    var resultBlock:(() -> Void)?
    
    //// 最大字数
    var contentMaxCount: Int = 200
    ///txtView 提示文字
    let placeHolder = "请输遇到的问题与建议…"
    var content: String = ""
    var orderId: String = ""
    
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
            fontCountLab.text =  "\(content.count)/\(contentMaxCount)"
        }else{
            contentTxtView.text = placeHolder
        }
    }
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
        lab.text = "0/\(contentMaxCount)"
        
        return lab
    }()
    /// 完成
    @objc func onClickRightBtn(){
        requestFeedBack()
    }
    //反馈
    func requestFeedBack(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        
        GYZNetWork.requestNetwork("Member/Order/feedback", parameters: ["feedback":content,"id":orderId],  success: { (response) in
            
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
            resultBlock!()
        }
        clickedBackBtn()
    }
}
extension FSOrderFeedBackVC : UITextViewDelegate{
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
        self.fontCountLab.text =  "\(textView.text.count)/\(contentMaxCount)"
    }
}
