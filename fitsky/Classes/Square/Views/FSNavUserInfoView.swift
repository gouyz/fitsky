//
//  FSNavUserInfoView.swift
//  fitsky
//  导航栏 用户信息View
//  Created by gouyz on 2019/8/27.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSNavUserInfoView: UIView {

    // MARK: 生命周期方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI(){
        addSubview(leftBtn)
        addSubview(rightBtn)
        addSubview(navBarView)
        addSubview(lineView)
        navBarView.addSubview(userImgView)
        navBarView.addSubview(vipImgView)
        navBarView.addSubview(nameLab)
        
        leftBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(self)
            make.top.equalTo(kStateHeight)
            make.width.equalTo(kTitleHeight)
        }
        navBarView.snp.makeConstraints { (make) in
            make.left.equalTo(leftBtn.snp.right)
            make.top.equalTo(self)
            make.right.equalTo(rightBtn.snp.left)
            make.bottom.equalTo(lineView.snp.top)
        }
        userImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.bottom.equalTo(-4)
            make.size.equalTo(CGSize.init(width: 36, height: 36))
        }
        vipImgView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(userImgView)
            make.size.equalTo(CGSize.init(width: 12, height: 12))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(userImgView.snp.right).offset(kMargin)
            make.centerY.equalTo(userImgView)
            make.right.equalTo(-kMargin)
            make.height.equalTo(30)
        }
        rightBtn.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(self)
            make.top.width.equalTo(leftBtn)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(klineWidth)
        }
    }
    /// 左侧返回
    lazy var leftBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_back_black"), for: .normal)
        
        return btn
    }()
    lazy var navBarView: UIView = {
        let navView = UIView()
        
        return navView
    }()
    /// 用户头像图片
    lazy var userImgView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = kGrayBackGroundColor
        imgView.cornerRadius = 18
        
        return imgView
    }()
    /// 大V
    lazy var vipImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_daren"))
    ///名称
    lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        lab.text = "Alison"
        
        return lab
    }()
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()
    /// 右侧按钮
    lazy var rightBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_more_gray"), for: .normal)
        
        return btn
    }()
}
