//
//  FSConmentSendView.swift
//  fitsky
//  发送评论view
//  Created by gouyz on 2019/8/22.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSConmentSendView: UIView {

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kGrayBackGroundColor
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        
        addSubview(bgView)
        bgView.addSubview(contentTxtView)
        addSubview(sendBtn)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(8)
            make.height.equalTo(34)
            make.right.equalTo(sendBtn.snp.left).offset(-kMargin)
        }
        contentTxtView.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.top.bottom.equalTo(bgView)
            make.right.equalTo(-5)
        }
        
        sendBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 60, height: 30))
            make.right.equalTo(-kMargin)
        }
        
    }
    ///背景view
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.cornerRadius = kCornerRadius
        
        return view
    }()
    ///输入框
    lazy var contentTxtView: UITextView = {
        let txtView = UITextView()
        txtView.backgroundColor = kWhiteColor
        txtView.font = k13Font
        txtView.textColor = kBlackFontColor
        
        return txtView
    }()
    /// 发送
    lazy var sendBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kGrayBackGroundColor
        btn.titleLabel?.font = k15Font
        btn.setTitleColor(kBlueFontColor, for: .normal)
        btn.setTitle("发送", for: .normal)
        
        return btn
    }()
}
//extension FSConmentSendView: UITextViewDelegate{
//    ///MARK UITextViewDelegate
//    func textViewDidBeginEditing(_ textView: UITextView) {
//
//        let text = textView.text
//        if text == placeHolder {
//            textView.text = ""
//            textView.textColor = kBlackFontColor
//        }
//
//    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//
//        if textView.text.isEmpty {
//            textView.text = placeHolder
//            textView.textColor = kGaryFontColor
//        }
//    }
//    func textViewDidChange(_ textView: UITextView) {
//
//        let text : String = textView.text
//
//        content = text
//    }
//}
