//
//  GYZCustomOutTopicAlertView.swift
//  fitsky
//  退出话题 alert
//  Created by gouyz on 2019/9/6.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class GYZCustomOutTopicAlertView: UIView {

    ///点击事件闭包
    var action:((_ alertView: GYZCustomOutTopicAlertView,_ index: Int) -> Void)?
    
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
        
        addSubview(bgView)
        bgView.addSubview(tagImgView)
        bgView.addSubview(titleLab)
        bgView.addSubview(desLab)
        bgView.addSubview(cancleBtn)
        bgView.addSubview(okBtn)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.centerY.equalTo(self)
            make.height.equalTo(170)
        }
        tagImgView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalTo(titleLab)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
        titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(tagImgView.snp.right).offset(kMargin)
            make.right.equalTo(-30)
            make.height.equalTo(50)
        }
        desLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLab)
            make.top.equalTo(titleLab.snp.bottom).offset(kMargin)
            make.height.equalTo(30)
        }
        
        okBtn.snp.makeConstraints { (make) in
            make.right.equalTo(titleLab)
            make.bottom.equalTo(-15)
            make.size.equalTo(CGSize.init(width: 32, height: 32))
        }
        cancleBtn.snp.makeConstraints { (make) in
            make.right.equalTo(okBtn.snp.left).offset(-30)
            make.bottom.size.equalTo(okBtn)
        }
    }
    ///整体背景
    lazy var backgroundView: UIView = UIView()
    
    lazy var bgView: UIView = {
        let bgview = UIView()
        bgview.backgroundColor = kWhiteColor
        bgview.cornerRadius = 15
        
        return bgview
    }()
    /// 
    lazy var tagImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_caution"))
    /// 标题
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.font = k16Font
        lab.textColor = kGaryFontColor
        lab.numberOfLines = 0
        lab.text = "退出该话题30天内不得申请该类型话题、并撤除管理特权"
        
        return lab
    }()
    /// 描述
    lazy var desLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kGaryFontColor
        lab.text = "你是否确定退出该话题？"
        
        return lab
    }()
    /// 取消
    lazy var cancleBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_btn_cancel"), for: .normal)
        btn.tag = 101
        btn.addTarget(self, action: #selector(clickedBtn(btn:)), for: .touchUpInside)
        return btn
    }()
    /// 确定
    lazy var okBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_btn_confirm"), for: .normal)
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
    
    
}
