//
//  FSNewsAdsHeaderView.swift
//  fitsky
//  资讯 广告 header
//  Created by gouyz on 2019/10/11.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSNewsAdsHeaderView: UIView {

    // MARK: 生命周期方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        self.addSubview(adsImgView)
        
        adsImgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.top.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.equalTo(self)
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

}
