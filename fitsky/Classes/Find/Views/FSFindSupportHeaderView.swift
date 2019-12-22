//
//  FSFindSupportHeaderView.swift
//  fitsky
//  发现 运动、美食等header
//  Created by gouyz on 2019/10/11.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSFindSupportHeaderView: UICollectionReusableView {
    
    /// 点击操作
    var onClickedOperatorBlock: ((_ index: Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        addSubview(adsImgView)
        addSubview(bgView)
        bgView.addSubview(firstBtn)
        bgView.addSubview(secondBtn)
        bgView.addSubview(thirdBtn)
        
        addSubview(nameLab)
        
        adsImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.height.equalTo((kScreenWidth - kMargin * 2) * 0.4)
        }
        
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(adsImgView.snp.bottom).offset(kMargin)
            make.height.equalTo(54)
        }
        firstBtn.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 80, height: 34))
        }
        secondBtn.snp.makeConstraints { (make) in
            make.left.equalTo(firstBtn.snp.right).offset(kMargin)
            make.size.centerY.equalTo(firstBtn)
        }
        thirdBtn.snp.makeConstraints { (make) in
            make.left.equalTo(secondBtn.snp.right).offset(kMargin)
            make.size.centerY.equalTo(firstBtn)
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(bgView.snp.bottom)
            make.right.equalTo(-kMargin)
            make.height.equalTo(kTitleHeight)
        }
    }
    
    /// 广告轮播图
    lazy var adsImgView: ZCycleView = {
        let adsView = ZCycleView()
        adsView.placeholderImage = UIImage.init(named: "icon_bg_ads_default")
//        adsView.setImagesGroup([UIImage.init(named: "icon_bg_ads_default"),UIImage.init(named: "icon_bg_ads_default"),UIImage.init(named: "icon_bg_ads_default")])
        
        adsView.pageControlAlignment = .center
        adsView.pageControlIndictirColor = kWhiteColor
        adsView.pageControlCurrentIndictirColor = kOrangeFontColor
        adsView.scrollDirection = .horizontal
        
        adsView.cornerRadius = 10
        
        return adsView
    }()
    ///
    lazy var bgView: UIView = {
        
        let view = UIView()
        view.backgroundColor = kBackgroundColor
        view.isUserInteractionEnabled = true
        
        return view
    }()
    ///
    lazy var firstBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("课程主题", for: .normal)
        btn.titleLabel?.font = k15Font
        btn.backgroundColor = kBlueFontColor
        btn.cornerRadius = 10
        
        btn.tag = 101
        btn.addTarget(self, action: #selector(onclickedOperator(sender:)), for: .touchUpInside)
        
        return btn
    }()
    ///
    lazy var secondBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("精彩课程", for: .normal)
        btn.titleLabel?.font = k15Font
        btn.backgroundColor = UIColor.UIColorFromRGB(valueRGB: 0xffa748)
        btn.cornerRadius = 10
        
        btn.tag = 102
        btn.addTarget(self, action: #selector(onclickedOperator(sender:)), for: .touchUpInside)
        
        return btn
    }()
    ///
    lazy var thirdBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kWhiteColor, for: .normal)
        btn.setTitle("精彩课程", for: .normal)
        btn.titleLabel?.font = k15Font
        btn.backgroundColor = UIColor.UIColorFromRGB(valueRGB: 0xf98c9a)
        btn.cornerRadius = 10
        btn.isHidden = true
        
        btn.tag = 103
        btn.addTarget(self, action: #selector(onclickedOperator(sender:)), for: .touchUpInside)
        
        return btn
    }()
    
    /// 名称
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.textColor = kBlackFontColor
        lab.font = k18Font
        lab.text = "精彩分享"
        
        return lab
    }()
    ///
    @objc func onclickedOperator(sender: UIButton){
        if onClickedOperatorBlock != nil {
            onClickedOperatorBlock!(sender.tag)
        }
    }
}
