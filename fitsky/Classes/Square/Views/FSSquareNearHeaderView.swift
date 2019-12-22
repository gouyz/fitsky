//
//  FSSquareNearHeaderView.swift
//  fitsky
//  广场 附近 header
//  Created by gouyz on 2019/9/6.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit
import TTGTagCollectionView

class FSSquareNearHeaderView: UIView {

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
        self.addSubview(categoryTagsView)
        
        adsImgView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
//            make.top.equalTo(kMargin)
            make.height.equalTo((kScreenWidth - 120) * 0.38 + 60)
        }
        categoryTagsView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(adsImgView.snp.bottom)
            make.height.equalTo(54)
        }
    }
    /// 广告轮播图
    lazy var adsImgView: ZCycleView = {
        let adsView = ZCycleView()
        adsView.placeholderImage = UIImage.init(named: "icon_bg_ads_default")
        adsView.itemSize = CGSize(width: width-120, height: (width-120) * 0.38)
        adsView.itemSpacing = 40
        adsView.itemZoomScale = 1.2
        adsView.itemCornerRadius = 8
        adsView.pageControlHeight = 20
        adsView.pageControlIndictirColor = kGrayLineColor
        adsView.pageControlCurrentIndictirColor = kOrangeFontColor
        
        return adsView
    }()
    
    /// 所有分类
    lazy var categoryTagsView: TTGTextTagCollectionView = {
        
        let view = TTGTextTagCollectionView()
        let config = view.defaultConfig
        config?.textFont = k15Font
        config?.textColor = kHeightGaryFontColor
        config?.selectedTextColor = kWhiteColor
        config?.borderColor = kGrayBackGroundColor
        config?.selectedBorderColor = kHightBlueFontColor
        config?.backgroundColor = kGrayBackGroundColor
        config?.selectedBackgroundColor = kHightBlueFontColor
        config?.cornerRadius = 10
        config?.selectedCornerRadius = 10
        config?.minWidth = 74
        view.scrollDirection = .horizontal
        config?.shadowOffset = CGSize.init(width: 0, height: 0)
        config?.shadowOpacity = 0
        config?.shadowRadius = 0
        view.numberOfLines = 1
        view.contentInset = UIEdgeInsets.init(top: kMargin, left: kMargin, bottom: kMargin, right: kMargin)
        view.showsHorizontalScrollIndicator = false
        view.horizontalSpacing = 15
        view.backgroundColor = kBackgroundColor
        
        return view
    }()
}
