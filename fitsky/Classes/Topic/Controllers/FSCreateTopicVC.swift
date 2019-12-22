//
//  FSCreateTopicVC.swift
//  fitsky
//  创建话题
//  Created by gouyz on 2019/9/6.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import MBProgressHUD

class FSCreateTopicVC: GYZWhiteNavBaseVC {
    
    ///txtView 提示文字
    let placeHolder = "导语："
    //// 最大字数
    var contentMaxCount: Int = 30

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "创建话题"
        self.view.backgroundColor = kWhiteColor
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("提交", for: .normal)
        rightBtn.titleLabel?.font = k15Font
        rightBtn.setTitleColor(kBlueFontColor, for: .normal)
        rightBtn.frame = CGRect.init(x: 0, y: 0, width: kTitleHeight, height: kTitleHeight)
        rightBtn.addTarget(self, action: #selector(onClickRightBtn), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        setUpUI()
        contentTxtView.delegate = self
    }
    
    func setUpUI(){
        view.addSubview(nameView)
        view.addSubview(lineView)
        view.addSubview(bgView)
        bgView.addSubview(contentTxtView)
        bgView.addSubview(fontCountLab)
        
        nameView.snp.makeConstraints { (make) in
            make.top.equalTo(kMargin + kTitleAndStateHeight)
            make.left.right.equalTo(view)
            make.height.equalTo(kTitleHeight)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameView)
            make.top.equalTo(nameView.snp.bottom)
            make.height.equalTo(klineDoubleWidth)
        }
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(lineView.snp.bottom).offset(kMargin)
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
    
    lazy var nameView: GYZLabAndFieldView = {
        let nView = GYZLabAndFieldView.init(desName: "话题名称", placeHolder: "请输入话题名称")
        nView.desLab.textColor = kGaryFontColor
        nView.textFiled.textColor = kGaryFontColor
        
        return nView
    }()
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = kGrayLineColor
        
        return view
    }()
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
        if nameView.textFiled.text!.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入话题标题")
            return
        }
        if contentTxtView.text.isEmpty {
            MBProgressHUD.showAutoDismissHUD(message: "请输入导语内容")
            return
        }
        requestCreateTopic()
    }
    
    ///创建话题
    func requestCreateTopic(){
        if !GYZTool.checkNetWork() {
            return
        }
        
        weak var weakSelf = self
        createHUD(message: "加载中...")
        GYZNetWork.requestNetwork("Dynamic/TopicPublish/create", parameters: ["title":nameView.textFiled.text!,"content":contentTxtView.text!],  success: { (response) in
            
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
extension FSCreateTopicVC : UITextViewDelegate
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
