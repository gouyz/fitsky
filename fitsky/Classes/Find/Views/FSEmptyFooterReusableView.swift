//
//
//  FSEmptyFooterReusableView.swift
//  fitsky
//  UIcollection 空页面 footer
//  Created by gouyz on 2019/11/25.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSEmptyFooterReusableView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kBackgroundColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI(){
        addSubview(contentLab)
        addSubview(iconImgView)
        
        iconImgView.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize.init(width: 37, height: 29))
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(iconImgView.snp.bottom).offset(kMargin)
            make.height.equalTo(20)
        }
    }
    
    lazy var iconImgView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_conment_empty"))
    /// 内容显示
    lazy var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k13Font
        lab.textColor = kHeightGaryFontColor
        lab.textAlignment = .center
        lab.text = "暂无信息"
        
        return lab
    }()
    
}
