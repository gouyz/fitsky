//
//  FSMineFuncCell.swift
//  fitsky
//  我的 cell
//  Created by gouyz on 2019/10/8.
//  Copyright © 2019 gyz. All rights reserved.
//

import UIKit

class FSMineFuncCell: UITableViewCell {

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
        bgView.addSubview(contentLab)
        bgView.addSubview(rightIconView)
        bgView.addSubview(lineView)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.right.equalTo(-kMargin)
            make.bottom.top.equalTo(contentView)
        }
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(kMargin)
            make.centerY.equalTo(bgView)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(kMargin)
            make.top.equalTo(bgView)
            make.bottom.equalTo(lineView.snp.top)
            make.width.equalTo(120)
        }
        contentLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(nameLab)
            make.right.equalTo(rightIconView.snp.left).offset(-5)
            make.left.equalTo(nameLab.snp.right).offset(kMargin)
        }
        rightIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.right.equalTo(-kMargin)
            make.size.equalTo(rightArrowSize)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(bgView)
            make.height.equalTo(klineWidth)
        }
    }
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = kWhiteColor
        
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
    
    /// 内容
    var contentLab : UILabel = {
        let lab = UILabel()
        lab.font = k12Font
        lab.textColor = kGaryFontColor
        lab.textAlignment = .right
        
        return lab
    }()
    /// 右侧箭头图标
    lazy var rightIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_right_arrow"))
    
    /// 分割线
    var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = kGrayLineColor
        return line
    }()

}
