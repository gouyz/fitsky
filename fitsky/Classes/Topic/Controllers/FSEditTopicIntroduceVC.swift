//
//  FSEditTopicIntroduceVC.swift
//  fitsky
//  导语编辑
//  Created by gouyz on 2019/9/6.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSEditTopicIntroduceVC: GYZWhiteNavBaseVC {
    
    /// 选择结果回调
    var resultBlock:((_ isRefesh: Bool) -> Void)?

    ///txtView 提示文字
    let placeHolder = "导语："
    //// 最大字数
    var contentMaxCount: Int = 30
    
    var topicId: String = ""
    var topicContent: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "导语编辑"
        self.view.backgroundColor = kWhiteColor
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("确定", for: .normal)
        rightBtn.titleLabel?.font = k15Font
        rightBtn.setTitleColor(kHeightGaryFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
        contentTxtView.delegate = self
        if topicContent.count > 0 {
            contentTxtView.text = topicContent
            self.fontCountLab.text =  "\(topicContent.count)/\(contentMaxCount)"
        }
    }
    
    func setUpUI(){
        view.addSubview(bgView)
        bgView.addSubview(contentTxtView)
        bgView.addSubview(fontCountLab)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kMargin + kTitleAndStateHeight)
            make.height.equalTo(140)
        }
        contentTxtView.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(fontCountLab.snp.top)
        }
        fontCountLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentTxtView)
            make.bottom.equalTo(bgView)
            make.height.equalTo(20)
        }
    }
    /// 背景View
    lazy var bgView: UIView = {
        let v = UIView()
        v.backgroundColor = kWhiteColor
        v.cornerRadius = kCornerRadius
        v.borderColor = kHeightGaryFontColor
        v.borderWidth = klineWidth
        
        return v
    }()
    /// 描述
    lazy var contentTxtView: UITextView = {
        
        let txtView = UITextView()
        txtView.font = k15Font
        txtView.textColor = kHeightGaryFontColor
        txtView.text = placeHolder
        
        return txtView
    }()
    /// 限制字数
    lazy var fontCountLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .right
        lab.text = "0/\(contentMaxCount)"
        
        return lab
    }()
    /// 提交
    @objc func onClickRightBtn(){
        if contentTxtView.text.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入导语内容")
            return
        }
        requestEditContent()
    }
    
    ///编辑导语
    func requestEditContent(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Dynamic/TopicPublish/update", parameters: ["id":topicId,"content":contentTxtView.text!],  success: { (response) in
            
            weakSelf?.hud?.hide(animated: true)
            GYZLog(response)
            MBProgressHUD.showAutoDismissHUD(message: response["msg"].stringValue)
            if response["result"].intValue == kQuestSuccessTag{//请求成功
                if weakSelf?.resultBlock != nil {
                    weakSelf?.resultBlock!(true)
                }
                weakSelf?.clickedBackBtn()
                
            }
            
        }, failture: { (error) in
            weakSelf?.hud?.hide(animated: true)
            GYZLog(error)
        })
    }
}
extension FSEditTopicIntroduceVC : UITextViewDelegate
{
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
            
            //截取500个字
            if textNum! > contentMaxCount {
                //                let index = textContent?.index((textContent?.startIndex)!, offsetBy: contentMaxCount)
                let str = textContent?.subString(start: 0, length: contentMaxCount)
                textView.text = str
            }
        }
        
        self.fontCountLab.text =  "\(textView.text.count)/\(contentMaxCount)"
    }
}
