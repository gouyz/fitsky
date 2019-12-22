//
//  FSTrainHeaderView.swift
//  fitsky
//  训练营 header
//  Created by gouyz on 2019/10/10.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSTrainHeaderView: UIView {
    
    /// 点击操作
    var onClickedOperatorBlock: ((_ index: Int) -> Void)?
    
    // MARK: 生命周期方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        self.addSubview(adsImgView)
        self.addSubview(bgView)
        bgView.addSubview(venueBtn)
        bgView.addSubview(courseBtn)
        bgView.addSubview(searchBtn)
        
        adsImgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(kMargin)
            make.height.equalTo((kScreenWidth - 120)*300/750*1.2)
        }
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(adsImgView.snp.bottom).offset(kMargin)
            make.height.equalTo(50)
            make.bottom.equalTo(-kMargin)
        }
        venueBtn.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 80, height: 30))
        }
        courseBtn.snp.makeConstraints { (make) in
            make.left.equalTo(venueBtn.snp.right).offset(15)
            make.centerY.size.equalTo(venueBtn)
        }
        searchBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-kMargin)
            make.centerY.equalTo(venueBtn)
            make.size.equalTo(CGSize.init(width: kTitleHeight, height: kTitleHeight))
        }
    }
    /// 广告轮播图
    lazy var adsImgView: ZCycleView = {
        let adsView = ZCycleView()
        adsView.placeholderImage = UIImage.init(named: "icon_bg_ads_default")
//        adsView.setImagesGroup([UIImage.init(named: "icon_bg_ads_default"),UIImage.init(named: "icon_bg_ads_default"),UIImage.init(named: "icon_bg_ads_default")])
        adsView.itemSize = CGSize(width: kScreenWidth - 120, height: (kScreenWidth - 120)*300/750)
        adsView.itemSpacing = 40
        adsView.itemZoomScale = 1.2
        adsView.itemCornerRadius = 6
        adsView.pageControlIndictirColor = kGrayLineColor
        adsView.pageControlCurrentIndictirColor = kOrangeFontColor
        
        return adsView
    }()
    
    ///
    lazy var bgView: UIView = {
        
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
        return view
    }()
    
    /// 场馆
    lazy var venueBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        btn.setTitle("健身馆", for: .normal)
        btn.titleLabel?.font = k15Font
        btn.backgroundColor = kGrayLineColor
        btn.cornerRadius = 15
        
        btn.tag = 101
        btn.addTarget(self, action: #selector(onclickedOperator(sender:)), for: .touchUpInside)
        
        return btn
    }()
    /// 精彩课程
    lazy var courseBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(kHeightGaryFontColor, for: .normal)
        btn.setTitle("精彩课程", for: .normal)
        btn.titleLabel?.font = k15Font
        btn.backgroundColor = kGrayLineColor
        btn.cornerRadius = 15
        
        btn.tag = 102
        btn.addTarget(self, action: #selector(onclickedOperator(sender:)), for: .touchUpInside)
        
        return btn
    }()
    /// 搜索
    lazy var searchBtn : UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "app_icon_seach"), for: .normal)
        btn.tag = 103
        btn.addTarget(self, action: #selector(onclickedOperator(sender:)), for: .touchUpInside)

        return btn
    }()
    ///
    @objc func onclickedOperator(sender: UIButton){
        if onClickedOperatorBlock != nil {
            onClickedOperatorBlock!(sender.tag)
        }
    }
}
