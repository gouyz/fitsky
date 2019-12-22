//
//  GYZIconLabArrowView.swift
//  fitsky
//  基本信息View 只包含左侧icon、左右2个label及右侧箭头
//  Created by gouyz on 2019/9/3.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class GYZIconLabArrowView: UIView {

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
        addSubview(iconView)
        addSubview(nameLab)
        addSubview(contentLab)
        addSubview(rightIconView)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(self)
            make.width.equalTo(80)
        }
        contentLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(nameLab)
            make.right.equalTo(rightIconView.snp.left).offset(-5)
            make.left.equalTo(nameLab.snp.right).offset(kMargin)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-kMargin)
            make.size.equalTo(rightArrowSize)
        }
    }
    
    /// 图标
    lazy var iconView: UIImageView = UIImageView()
    
    /// cell title
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k15Font
        lab.textColor = kGaryFontColor
        
        return lab
    }()
    
    /// 内容
    var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kBlueFontColor
        lab.textAlignment = .right
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
}
