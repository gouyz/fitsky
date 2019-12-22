//
//  FSCustomCooperateAlertView.swift
//  fitsky
//  合作洽谈 弹出框
//  Created by gouyz on 2019/10/25.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSCustomCooperateAlertView: UIView {
    
    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(){
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        self.init(frame: rect)
        
        self.backgroundColor = UIColor.clear
        
        backgroundView.frame = rect
        backgroundView.backgroundColor = kBlackColor
        addSubview(backgroundView)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupUI(){
        
        addSubview(cancleBtn)
        addSubview(bgView)
        bgView.addSubview(emailDesLab)
        bgView.addSubview(emailLab)
        bgView.addSubview(contentDesLab)
        bgView.addSubview(contentLab)
        
        cancleBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgView.snp.top).offset(-50)
            make.right.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
        bgView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(120)
        }
        emailDesLab.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(kMargin)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        emailLab.snp.makeConstraints { (make) in
            make.left.equalTo(emailDesLab.snp.right).offset(5)
            make.top.height.equalTo(emailDesLab)
            make.right.equalTo(-kMargin)
        }
        contentDesLab.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(emailDesLab)
            make.top.equalTo(emailDesLab.snp.bottom).offset(kMargin)
        }
        
        contentLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(emailLab)
            make.top.equalTo(contentDesLab)
            make.bottom.equalTo(-kMargin)
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
    ///
    lazy var emailDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "合作邮箱："
        
        return lab
    }()
    ///
    lazy var emailLab : UILabel = {
        let lab = UILabel()
        lab.font = k16Font
        lab.textColor = kBlueFontColor
        lab.text = "jyn@fitsky.net"
        
        return lab
    }()
    ///
    lazy var contentDesLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kBlackFontColor
        lab.text = "合作须知："
        
        return lab
    }()
    ///
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.numberOfLines = 2
        lab.text = "来邮请附上合作意向，合作方式、合作渠道、以及联系方式。"
        
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
    /// 点击事件/// 点击事件
    ///
    /// - Parameter btn:
    @objc func clickedBtn(btn: UIButton){
        
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
    
}
