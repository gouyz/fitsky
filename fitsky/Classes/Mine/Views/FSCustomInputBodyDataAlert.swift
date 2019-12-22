//
//  FSCustomInputBodyDataAlert.swift
//  fitsky
//  身体数据 填写 alert
//  Created by gouyz on 2019/10/18.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSCustomInputBodyDataAlert: UIView {

    ///点击事件闭包
    var action:((_ alertView: FSCustomInputBodyDataAlert,_ index: Int) -> Void)?
    
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(title: String,placeholder: String,content:String,unit: String){
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.init(frame: rect)
        
        self.backgroundColor = UIColor.clear
        
        backgroundView.frame = rect
        backgroundView.backgroundColor = kBlackColor
        addSubview(backgroundView)
        
        setupUI()
        titleLab.text = title
        inputTxtFiled.placeholder = placeholder
        if content.count > 0 {
            inputTxtFiled.text = content
            self.okBtn.isUserInteractionEnabled = true
            self.okBtn.backgroundColor = kBlueFontColor
        }else{
            self.okBtn.isUserInteractionEnabled = false
            self.okBtn.backgroundColor = kBtnNoClickBGBlueColor
        }
        
        desLab.text = unit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupUI(){
        
        addSubview(cancleBtn)
        addSubview(bgView)
        bgView.addSubview(inputTxtFiled)
        bgView.addSubview(lineView)
        bgView.addSubview(titleLab)
        bgView.addSubview(desLab)
        bgView.addSubview(okBtn)
        
        cancleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.right.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        bgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(cancleBtn.snp.bottom).offset(30)
            make.size.equalTo(CGSize.init(width: 280, height: 200))
        }
        titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        inputTxtFiled.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgView)
            make.top.equalTo(titleLab.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(kTitleHeight)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(inputTxtFiled)
            make.top.equalTo(inputTxtFiled.snp.bottom)
            make.height.equalTo(klineWidth)
        }
        
        desLab.snp.makeConstraints { (make) in
            make.left.equalTo(inputTxtFiled.snp.right)
            make.centerY.equalTo(inputTxtFiled)
            make.height.equalTo(inputTxtFiled)
            make.width.equalTo(50)
        }
        
        okBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(-20)
            make.left.equalTo(20)
            make.height.equalTo(50)
        }
    }
    ///整体背景
    lazy var backgroundView: UIView = UIView()
    
    lazy var bgView: UIView = {
        let bgview = UIView()
        bgview.backgroundColor = kWhiteColor
        bgview.cornerRadius = kCornerRadius
        
        return bgview
    }()
    /// 标题
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = k16Font
        lab.textColor = kBlackFontColor
        lab.textAlignment = .center
        lab.text = "请输入当前身高"
        
        return lab
    }()
    /// 输入内容
    lazy var inputTxtFiled : UITextField = {
        
        let textFiled = UITextField()
        textFiled.font = k15Font
        textFiled.textColor = kBlackFontColor
//        textFiled.clearButtonMode = .whileEditing
        textFiled.textAlignment = .center
        textFiled.placeholder = "请输入身高"
        textFiled.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        return textFiled
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 单位
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k16Font
        lab.textColor = kBlackFontColor
        lab.text = "cm"
        
        return lab
    }()
    /// 取消
    lazy var cancleBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_btn_close_white"), for: .normal)
        btn.tag = 101
        btn.addTarget(self, action: #selector(clickedBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 确定
    lazy var okBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = kBtnNoClickBGBlueColor
        btn.isUserInteractionEnabled = false
        btn.setTitle("保存", for: .normal)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.titleLabel?.font = k15Font
        btn.cornerRadius = 25
        
        btn.tag = 102
        btn.addTarget(self, action: #selector(clickedBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 点击事件/// 点击事件
    ///
    /// - Parameter btn:
    @objc func clickedBtn(btn: UIButton){
        
        let tag = btn.tag - 100
        
        if action != nil {
            action!(self, tag)
        }
        
        hide()
        
    }
    
    func show(){
        UIApplication.shared.keyWindow?.addSubview(self)
        
        showBackground()
        showAlertAnimation()
    }
    func hide(){
        bgView.isHidden = true
        hideAlertAnimation()
        self.removeFromSuperview()
    }
    
    fileprivate func showBackground(){
        backgroundView.alpha = 0.0
        UIView.beginAnimations("fadeIn", context: nil)
        UIView.setAnimationDuration(0.35)
        backgroundView.alpha = 0.6
        UIView.commitAnimations()
    }
    
    fileprivate func showAlertAnimation(){
        let popAnimation = CAKeyframeAnimation(keyPath: "transform")
        popAnimation.duration = 0.3
        popAnimation.values   = [
            NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
            NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)),
            NSValue.init(caTransform3D: CATransform3DIdentity)
        ]
        
        popAnimation.isRemovedOnCompletion = true
        popAnimation.fillMode = CAMediaTimingFillMode.forwards
        bgView.layer.add(popAnimation, forKey: nil)
    }
    
    fileprivate func hideAlertAnimation(){
        UIView.beginAnimations("fadeIn", context: nil)
        UIView.setAnimationDuration(0.35)
        backgroundView.alpha = 0.0
        UIView.commitAnimations()
    }

    @objc func textFieldDidChange(textField:UITextField){
        if textField == self.inputTxtFiled {
            if textField.text?.count > 0 {
                self.okBtn.isUserInteractionEnabled = true
                self.okBtn.backgroundColor = kBlueFontColor
            }else{
                self.okBtn.isUserInteractionEnabled = false
                self.okBtn.backgroundColor = kBtnNoClickBGBlueColor
            }
        }
    }
}
