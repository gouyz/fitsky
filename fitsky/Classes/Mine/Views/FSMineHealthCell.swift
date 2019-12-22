//
//  FSMineHealthCell.swift
//  fitsky
//  我的 运动身高cell
//  Created by gouyz on 2019/10/8.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSMineHealthCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = kWhiteColor
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(bgView)
        bgView.addSubview(iconView)
        bgView.addSubview(nameLab)
        bgView.addSubview(rightIconView)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.top.equalTo(kMargin)
            make.bottom.equalTo(contentView)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.bottom.equalTo(bgView)
            make.right.equalTo(rightIconView.snp.left).offset(-kMargin)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(rightArrowSize)
        }
    }
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        view.cornerRadius = kCornerRadius
        view.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 2
        view.layer.shadowColor = kGrayLineColor.cgColor
        view.borderColor = kWhiteColor
        view.borderWidth = klineWidth
        // true的情况不出阴影效果
        view.layer.masksToBounds = false
        
        return view
    }()
    /// 图标
    lazy var iconView: UIImageView = UIImageView()
    
    /// cell title
    lazy var nameLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kGaryFontColor
        
        return lab
    }()
    
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "app_icon_big_right"))

}
